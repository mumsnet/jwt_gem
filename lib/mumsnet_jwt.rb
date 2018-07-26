module MumsnetJWT
  class << self
    require 'jwt'
    require 'json'
    require 'base64'

    DEFAULT_EXP = Time.now.to_i + 60 * 60 * 24
    def tokenify(extra_payload: {})
      payload = { client_id: ENV['JWT_CLIENT_ID'], iss: ENV['JWT_ISSUER'], exp: DEFAULT_EXP }.merge(extra_payload)
      JWT.encode payload, jwt_secret, 'HS256' unless jwt_secret.nil?
    end

    def check_token(token)
      client_id = client_id_from_token(token)
      decode_token(token: token, key: 'client_id') == client_id
    rescue StandardError
      false
    end

    def decode_token(token:, key: nil)
      client_id = client_id_from_token(token)
      decoded_token = JWT.decode(token, jwt_secret(client_id), true, algorithm: 'HS256') unless jwt_secret(client_id).nil?
      if key
        decoded_token[0][key]
      else
        decoded_token
      end
    rescue StandardError·
      nil
    end

    def client_id_from_token(token)
      JSON.parse(Base64.decode64(token.split('.')[1]))['client_id']
    end

    def jwt_secret(client_id = ENV['JWT_CLIENT_ID'])
      jwt_secret = nil
      JSON.parse(ENV['JWT_SECRETS']).each do |item|
        jwt_secret = item['secret'] if item['client_id'] == client_id
      end
      jwt_secret
    end
  end
end
