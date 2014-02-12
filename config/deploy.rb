# config valid only for Capistrano 3.1
lock '3.1.0'
set :application, 'my_app_name'
set :repo_url, 'ezuhaib@bitbucket.org/ezuhaib/psymic.git'
set :deploy_to, '/home/ezuhaib/apps/psymic'
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

# Unconfirmed settings... imported from a capistrano 2 project.
set :migrate_target,  :current
set :ssh_options,     { forward_agent: true }
set :rails_env,       "production"
set :user,            "ezuhaib"
set :group,           "staff"
set :use_sudo,        false
set :normalize_asset_timestamps, false
set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }
server "107.150.7.215", roles: [:app, :web, :db], :primary => true
set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }


# The recipe.Not confirmed if works.
namespace :deploy do
  ########################################
  desc "Deploy your application"
  task :default do
    update
    restart
  end
  ########################################
  desc "Setup your git-based deployment app"
  task :setup, except: { no_release: true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end
  ########################################
  task :cold do
    update
    migrate
  end
  ########################################
  task :update do
    transaction do
      update_code
    end
  end
  ########################################
  desc "Update the deployed code."
  task :update_code, except: { no_release: true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end
  ########################################
  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    transaction do
      update_code
    end
    migrate
    restart
  end
  ########################################
  task :finalize_update, except: { no_release: true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{shared_path}/system #{latest_release}/public/system &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&
      ln -sf #{shared_path}/config/database.yml #{latest_release}/config/database.yml
    CMD

    #precompile the assets
    run "cd #{latest_release}; bundle exec rake assets:precompile"

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", env: { "TZ" => "UTC" }
    end
  end
  ########################################
  desc "Zero-downtime restart of Unicorn"
  task :restart, except: { no_release: true } do
    run "kill -s USR2 `cat /tmp/unicorn.psymic.pid`"
  end
  ########################################
  desc "Start unicorn"
  task :start, except: { no_release: true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end
  ########################################
  desc "Stop unicorn"
  task :stop, except: { no_release: true } do
    run "kill -s QUIT `cat /tmp/unicorn.psymic.pid`"
  end
  ########################################
  namespace :rollback do
  ########################################
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, except: { no_release: true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end
   ########################################
    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, except: { no_release: true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end
  ########################################
    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end
