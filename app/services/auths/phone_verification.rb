module Auths
  class PhoneVerification < BaseService
    class VerifyDeclined < StandardError; end

    def initialize(phone_number)
      super

      @phone_number = phone_number
      @action = action
    end

    def send_otp
      if Rails.env.development? || whitelisted?
        logger.info "Sent OTP code to #{phone_number}"
      else
        ::SendOtpCodeJob.perform_later(phone_number)
      end
    end

    def verify_otp(otp_code)
      return true if Rails.env.development? || whitelisted?

      check = twilio.verification_checks.create(to: phone_number, code: otp_code)
      raise VerifyDeclined unless check.status == 'approved'
    end

    private

    attr_reader :phone_number, :action

    def twilio
      ::TwilioGateway.new.verification_service
    end

    def whitelisted?
      whitelisted_regex = ENV['whitelisted_phone_regex'] || '00000000000'
      phone_number.match(/^#{Regexp.quote(whitelisted_regex)}/)
    end
  end
end
