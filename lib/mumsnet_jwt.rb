module MumsnetJWT
  class << self
    require 'jwt'
    DEFAULT_EXP = Time.now.to_i + 60 * 60 * 24
    def tokenify(extra_payload: {})
      payload = { jwt_client_id: ENV['JWT_CLIENT_ID'], iss: ENV['JWT_ISSUER'], exp: DEFAULT_EXP }.merge(extra_payload)
      JWT.encode payload, jwt_secret, 'HS256' unless jwt_secret.nil?
    end

    def check_token(token, jwt_client_id = ENV['JWT_CLIENT_ID'])
      decode_token(token: token, key: 'jwt_client_id') == jwt_client_id
    rescue StandardError
      false
    end

    def decode_token(token:, key: nil, jwt_client_id: ENV['JWT_CLIENT_ID'])
      decoded_token = JWT.decode(token, jwt_secret(jwt_client_id), true, algorithm: 'HS256') unless jwt_secret(jwt_client_id).nil?
      if key
        decoded_token[0][key]
      else
        decoded_token
      end
    rescue StandardError·
      nil
    end

    def jwt_secret(jwt_client_id = ENV['JWT_CLIENT_ID'])
      jwt_secret = nil
      JSON.parse(ENV['JWT_SECRETS']).each do |item|
        jwt_secret = item['secret'] if item['client_id'] == jwt_client_id
      end
      jwt_secret
    end
  end
end
