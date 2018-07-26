module MumsnetJWT
  class << self
    require 'jwt'
    DEFAULT_EXP = Time.now.to_i + 60 * 60 * 24
    def tokenify(extra_payload: {})
      payload = { jwt_client_id: ENV['JWT_CLIENT_ID'], iss: ENV['JWT_ISSUER'], exp: DEFAULT_EXP }.merge(extra_payload)
      JWT.encode payload, jwt_secret, 'HS256' unless jwt_secret.nil?
    end

    def check_token(token)
      decode_token(token: token, key: 'client_id') == ENV['JWT_CLIENT_ID']
    rescue StandardError
      false
    end

    def decode_token(token:, key: nil)
      decoded_token = JWT.decode(token, jwt_secret, true, algorithm: 'HS256') unless jwt_secret.nil?
      if key
        decoded_token[0][key]
      else
        decoded_token
      end
    rescue StandardError
      nil
    end

    def jwt_secret
      jwt_secret = nil
      JSON.parse(ENV['JWT_SECRETS']).each do |item|
        jwt_secret = item['secret'] if item['client_id'] == ENV['JWT_CLIENT_ID']
      end
      jwt_secret
    end
  end
end
