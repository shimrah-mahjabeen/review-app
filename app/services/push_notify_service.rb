class PushNotifyService < BaseService
  def initialize(device_ids, message)
    raise ArgumentError, 'fcm ids is empty' if device_ids.blank?
    raise ArgumentError, 'message is empty' if message.blank?
    raise StandardError, 'No firebase key'  if Rails.application.credentials.firebase[:server_key].blank?

    @device_ids = device_ids
    @message = message
    @errors = []
  end

  def execute
    send
  end

  private

  def send
    fcm = FCM.new(Rails.application.credentials.firebase[:server_key])
    fcm.send(@device_ids, notification: @message)
  end
end
