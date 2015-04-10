# config valid only for Capistrano 3.1
lock '3.1.0'

set :linked_files,    %w(config/database.yml config/application.yml config/secrets.yml)
set :linked_dirs,     %w(tmp/pids tmp/sockets log)
