# config valid only for Capistrano 3.1
lock '3.1.0'

set :linked_files,    %w(config/database.yml config/application.yml)
set :linked_dirs,     %w(tmp/pids tmp/sockets log)

set :default_env, {
  'RACK_ENV' => 'production'
}