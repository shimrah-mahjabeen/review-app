class SendSmsService < BaseService
  def initialize(text, phone_number)
    raise ArgumentError, 'text is empty' if text.blank?
    raise ArgumentError, 'phone_number is empty' if phone_number.blank?

    @text = text
    @phone_number = phone_number
    @errors = []
  end

  def execute
    if Rails.env.production?
      send
    else
      logger.info 'sent SMS'
      logger.info "      to: #{parsed_mobile_number}"
      logger.info "    body: #{@text}"
    end
  end

  private

  def send
    phone_number = Rails.application.credentials.twilio[:phone_number]
    Twilio::REST::Client.new(
      Rails.application.credentials.twilio[:sid],
      Rails.application.credentials.twilio[:token]
    ).messages.create(
      from: phone_number,
      to: parsed_mobile_number,
      body: @text
    )
  end

  def parsed_mobile_number
    @phone_number.gsub(/^090/, '+8190')
                 .gsub(/^080/, '+8180')
                 .gsub(/^070/, '+8170')
                 .gsub(/^050/, '+8150')
  end
end
