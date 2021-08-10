class BaseService
  def initialize(*_args); end

  def logger
    @logger ||= Rails.logger
  end

  def slack_error_notifier
    return nil if ENV['SLACK_ERROR_WEBHOOK_URL'].blank?

    Slack::Notifier.new(ENV['SLACK_ERROR_WEBHOOK_URL'])
  end
end
