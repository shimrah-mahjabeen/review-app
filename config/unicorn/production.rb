app_path = '/home/ec2-user/app'
working_directory "#{app_path}/current"
pid "#{app_path}/current/tmp/pids/unicorn.pid"
listen '/var/run/unicorn.sock', backlog: 64

stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

worker_processes 4
timeout 30

before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

preload_app true

# Change pid
before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"

  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # TODO: log or notification
    end
  end
end

# Estabish Connection
after_fork do |_, _|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
