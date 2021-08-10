module Auths
  class PhoneNumber
    include ActiveModel::Model

    attr_reader :formatted_phone_number

    def initialize(params = {})
      @formatted_phone_number = normalize_phone_number(params[:phone_number])
    end

    validates :formatted_phone_number,
              presence: true,
              format: { with: /\A(\(\+\d{1,3}\)|\+?\d+)?\d+\z/ }

    def persisted?
      false
    end

    private

    def normalize_phone_number(number)
      if Rails.env.development?
        number.gsub('-', '')
              .gsub(/^080/, '+8180')
              .gsub(/^090/, '+8490')
              .gsub(/^093/, '+8493')
              .gsub(/^098/, '+8498')
      else
        number.gsub('-', '')
              .gsub(/^090/, '+8190')
              .gsub(/^080/, '+8180')
              .gsub(/^070/, '+8170')
              .gsub(/^050/, '+8150')
      end
    end
  end
end
