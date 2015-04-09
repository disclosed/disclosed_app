set :application, 'disclosed'
set :repo_url, 'git@github.com:disclosed/disclosed_app.git'

set :deploy_to, '/home/deploy/disclosed'

# Use databse.yml from the shared folder
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Config files to be copied over by deploy:setup_config
set :config_files, %w(
  database.example.yml
)

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
