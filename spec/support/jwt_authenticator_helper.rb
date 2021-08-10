module TokenSpecHelper
  include JwtAuthenticator

  def jwt_token(resource)
    raw_refresh_auth_token = resource.refresh_auth_tokens.create.raw_token
    encode(resource.id, raw_refresh_auth_token)
  end
end

RSpec.configure do |config|
  config.include TokenSpecHelper
end
