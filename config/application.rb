require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Assignment
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :en
    config.i18n.available_locales = :en
    config.paths.add 'lib', eager_load: true
    config.generators do |g|
      g.test_framework :rspec
    end

    config.active_job.queue_adapter = :sidekiq

    # Permit cross origin
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 expose: ['X-Authentication-Token'],
                 methods: %w[get post options head]
      end
    end
  end
end
