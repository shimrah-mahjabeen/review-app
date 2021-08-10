module TokenEncrypted
  extend ActiveSupport::Concern

  included do
    before_validation(on: :create) { set_crypted_token }
    attr_accessor :raw_token
  end

  class_methods do
    def search_by_token(raw_token)
      encrypted_token = encrypt_token(raw_token)
      find_by(encrypted_token: encrypted_token)
    end

    def encrypt_token(token)
      Digest::SHA256.hexdigest token
    end
  end

  private

  def set_crypted_token
    self.raw_token ||= SecureRandom.uuid
    self.encrypted_token = self.class.encrypt_token(raw_token)
  end
end
