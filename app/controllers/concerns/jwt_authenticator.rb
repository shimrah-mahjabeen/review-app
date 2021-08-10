module JwtAuthenticator
  require 'jwt'

  TOKEN_EXPIRY_PERIOD = (ENV['TOKEN_EXPRITY_PERIOD'] || 5).to_i
  KEY = Rails.application.credentials.secret_key_base

  def authenticate_identical!
    if cookies.encrypted[:authentication_token]
      load_current_identical(cookies.encrypted[:authentication_token]) || head(:unauthorized)
    else
      authenticate_or_request_with_http_token do |token, _|
        return load_current_identical(token)
      end
    end
  end

  def load_current_identical(token)
    return false unless token

    decoded_token = decode_or_renew_token(token)
    return false if BlacklistedAuthToken.exists?(jti: decoded_token['jti'])

    return unless defined?(decoded_token['identical_type'])

    @current_identical = decoded_token['identical_type']
                         .constantize
                         .find_by(id: decoded_token['identical_id'])
    !!@current_identical
  end

  def decode(encoded_token)
    decoded_dwt = JWT.decode(encoded_token, KEY, true, algorithm: 'HS256')
    decoded_dwt.first
  end

  def decode_or_renew_token(token)
    decode(token)
  rescue JWT::ExpiredSignature
    raw_refresh_token = cookies.encrypted['refresh_auth_token'] || request.headers['X-Refresh-Token']
    decode(refresh_token!(raw_refresh_token))
  end

  def refresh_token!(raw_refresh_token)
    current_refresh_token = RefreshAuthToken.search_by_token(raw_refresh_token)
    sign_me_in(current_refresh_token.identical, raw_refresh_token)
  end

  def encode(identical_id, identical_type, raw_refresh_auth_token)
    preload = { identical_id: identical_id,
                identical_type: identical_type,
                exp: TOKEN_EXPIRY_PERIOD.minutes.from_now.to_i,
                jti: SecureRandom.uuid,
                raw_refresh_auth_token: raw_refresh_auth_token }
    JWT.encode(preload, KEY, 'HS256')
  end

  def sign_me_in(identical, current_rfr_token = nil)
    raw_refresh_auth_token = current_rfr_token || identical.refresh_auth_tokens.create.raw_token
    token = encode(identical.id, identical.class.name, raw_refresh_auth_token)
    send_authentication_token(token)
    send_refresh_auth_token(raw_refresh_auth_token)
    token
  end

  def sign_me_out
    current_token = cookies.encrypted[:authentication_token]
    if current_token
      clear_token(current_token)
    else
      authenticate_or_request_with_http_token do |token, _|
        clear_token token
      end
    end
  end

  private

  def clear_token(token)
    decoded_token = decode(token)
    @current_identical&.blacklisted_tokens&.create(jti: decoded_token['jti'])
    RefreshAuthToken.search_by_token(decoded_token['raw_refresh_auth_token']).destroy
    cookies.delete(:authentication_token)
    cookies.delete(:refresh_auth_token)
  end

  def send_authentication_token(authentication_token)
    response.headers['X-Authentication-Token'] = authentication_token
    cookies.encrypted[:authentication_token] = { value: authentication_token,
                                                 expires: 2.months.from_now,
                                                 httponly: true,
                                                 same_site: 'Lax',
                                                 secure: Rails.env.production? }
  end

  def send_refresh_auth_token(refresh_auth_token)
    response.headers['X-Refresh-Auth-Token'] = refresh_auth_token
    cookies.encrypted[:refresh_auth_token] = { value: refresh_auth_token,
                                               expires: 2.months.from_now,
                                               httponly: true,
                                               same_site: 'Lax',
                                               secure: Rails.env.production? }
  end
end
