lock '~> 3.14.1'
set :application, 'assignment'
set :repo_url, ''
set :branch, ENV['branch'] || 'master'
set :deploy_to, '/home/ec2-user/app'
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
  'vendor/bundle', 'public/system', 'public/packs'
)
set :linked_files, %w[.env config/master.key]
set :keep_releases, 5
set :rbenv_ruby, '3.0.0'
set :log_level, :debug
set :unicorn_pid, '/home/ec2-user/app/current/tmp/pids/unicorn.pid'
set :unicorn_rack_env, 'deployment'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
