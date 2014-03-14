# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'psymic'
set :repo_url, 'git@github.com:ezuhaib/psymic.git'

set :linked_files, %w{config/local_env.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}
set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :rails_env,       "production"

set :migrate_target,  :current
set :ssh_options,     { forward_agent: true , port:ENV["SSH_PORT"]}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
