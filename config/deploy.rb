set :application, 'bidzone'

set :repo_url, 'git@github.com:XXX/XXX.git'

set :deploy_to, '/home/deploy/bidzone'

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :linked_dirs, fetch(:linked_dirs) + %w{public/system public/uploads}

#set :shared_children, shared_children + %w{public/uploads}

namespace :rails do
  desc "Run the console on a remote server."
  task :console do
    on roles(:app) do |h|
      execute_interactively "RAILS_ENV=#{fetch(:rails_env)} bundle exec rails console", h.user
    end
  end

  def execute_interactively(command, user)
    info "Connecting with #{user}@#{host}"
    cmd = "ssh #{user}@#{host} -p 22 -t 'cd #{fetch(:deploy_to)}/current && #{command}'"
    exec cmd
  end
end

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

namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'bower:install CI=true'
      end
    end
  end
end
before 'deploy:compile_assets', 'bower:install'

# # config valid only for Capistrano 3.1
# lock '3.1.0'
#
# set :application, 'my_app_name'
# set :repo_url, 'git@example.com:me/my_repo.git'
#
# # Default branch is :master
# # ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
#
# # Default deploy_to directory is /var/www/my_app
# # set :deploy_to, '/var/www/my_app'
#
# # Default value for :scm is :git
# # set :scm, :git
#
# # Default value for :format is :pretty
# # set :format, :pretty
#
# # Default value for :log_level is :debug
# # set :log_level, :debug
#
# # Default value for :pty is false
# # set :pty, true
#
# # Default value for :linked_files is []
# # set :linked_files, %w{config/database.yml}
#
# # Default value for linked_dirs is []
# # set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
#
# # Default value for default_env is {}
# # set :default_env, { path: "/opt/ruby/bin:$PATH" }
#
# # Default value for keep_releases is 5
# # set :keep_releases, 5
#
# namespace :deploy do
#
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       # execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end
#
#   after :publishing, :restart
#
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
#
# end
