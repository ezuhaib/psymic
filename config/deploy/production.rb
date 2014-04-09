role :web,    '107.150.7.215'
role :app,    '107.150.7.215'
role :db,     '107.150.7.215'
server '107.150.7.215', user: "ezuhaib" , roles: %w{web app db}, primary: true

set :deploy_user,     ENV["REMOTE_USER"]
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:application)}"
set :deploy_via,      :remote_cache

set :unicorn_pid, "/tmp/unicorn.psymic.pid"
set :unicorn_rack_env, "production"