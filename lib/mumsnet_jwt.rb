module MumsnetJWT
  class << self
    require 'jwt'
    DEFAULT_EXP = Time.now.to_i + 60 * 60 * 24
    def tokenify(extra_payload: {})
      payload = { access_token: ENV['API_ACCESS_TOKEN'], iss: ENV['JWT_ISSUER'], exp: DEFAULT_EXP }.merge(extra_payload)
      token = JWT.encode payload, ENV['JWT_SECERET'], 'HS256'
      token
    end

    def check_token(token)
      decode_token(token: token, key: 'access_token') == ENV['API_ACCESS_TOKEN']
    rescue StandardError
      false
    end

    def decode_token(token:, key: nil)
      decoded_token = JWT.decode(token, ENV['JWT_SECERET'], true, algorithm: 'HS256')
      if key
        decoded_token[0][key]
      else
        decoded_token
      end
    rescue StandardError
      nil
    end
  end
end
