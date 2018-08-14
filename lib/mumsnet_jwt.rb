module MumsnetJWT
  class << self
    require 'jwt'
    require 'json'
    require 'base64'
    require 'logger'
    @logger = Logger.new(STDOUT)
    DEFAULT_EXP = Time.now.utc.to_i + 60 * 60 * 24
    def tokenify(extra_payload: {})
      return false if env_defined?
      payload = { client_id: ENV['JWT_CLIENT_ID'], iss: ENV['JWT_ISSUER'], exp: DEFAULT_EXP }.merge(extra_payload)
      JWT.encode payload, jwt_secret, 'HS256' unless jwt_secret.nil?
    end

    def check_authorization_header(header)
      return false if env_defined?
      return false unless header.split(' ').first == 'Bearer'
      token = header.split(' ').last
      check_token(token)
    rescue StandardError => e
      puts "JWT ERROR:"
      puts e
      puts 'END JWT ERROR'
      false
    end

    def check_token(token)
      return false if env_defined?
      client_id = client_id_from_token(token)
      if !client_id.nil?
        decode_token(token: token, key: 'client_id') == client_id
      else
        false
      end
    rescue StandardError => e
      puts "JWT ERROR:"
      puts e
      puts 'END JWT ERROR'
      false
    end

    def decode_token(token:, key: nil)
      return nil if env_defined?
      client_id = client_id_from_token(token)
      decoded_token = JWT.decode(token, jwt_secret(client_id), true, algorithm: 'HS256') unless jwt_secret(client_id).nil?
      if key
        decoded_token[0][key]
      else
        decoded_token
      end
    rescue StandardError· => e
      puts "JWT ERROR:"
      puts e
      puts 'END JWT ERROR'
      nil
    end

    private

    def env_defined?
      ENV['JWT_CLIENT_ID'].nil? || ENV['JWT_SECRETS'].nil? || ENV['JWT_ISSUER'].nil?
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
