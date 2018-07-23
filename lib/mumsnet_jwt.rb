module MumsnetJWT
  class << self
    require 'jwt'
    DEFAULT_EXP = Time.now.to_i + 60 * 60 * 24
    def tokenify(extra_payload: {})
      payload = { jwt_check: ENV['JWT_CHECK'], iss: ENV['JWT_ISSUER'], exp: DEFAULT_EXP }.merge(extra_payload)
      token = JWT.encode payload, ENV['JWT_SECRET'], 'HS256'
      token
    end

    def check_token(token)
      decode_token(token: token, key: 'jwt_check') == ENV['JWT_CHECK']
    rescue StandardError
      false
    end

    def decode_token(token:, key: nil)
      decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
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
