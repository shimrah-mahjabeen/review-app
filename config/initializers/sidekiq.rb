redis_conn = { url: ENV['REDIS_URL'] || 'redis://localhost:6379' }

Sidekiq.configure_server do |config|
  config.redis = redis_conn
end

Sidekiq.configure_client do |config|
  config.redis = redis_conn
end
