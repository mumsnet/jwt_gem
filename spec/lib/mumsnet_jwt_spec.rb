RSpec.describe MumsnetJWT do
  ENV['JWT_SECRETS'] = '[{"client_id": "testing", "secret": "12345"}]'
  ENV['JWT_CLIENT_ID'] = 'testing'
  before(:each) do
    @token = described_class.tokenify
  end

  describe '#tokenify' do
    it 'should generate a valid jwt token' do
      expect(@token.split('.').count).to be(3)
      # Valid jwt tokens have 3 .'s
      expect(Base64.decode64(@token.split('.')[1])).to include(ENV['JWT_CLIENT_ID'])
      # Expect the token to have the Client id
      expect(described_class.check_token(@token)).to be_truthy
    end
  end

  describe '#check_authorization_header' do
    it 'should validate a Bearer Authentication header' do
      expect(described_class.check_authorization_header("Bearer #{@token}")).to be_truthy
      # Used for as Authentication header
    end

    it 'should return false if header is nil or invalid' do
      expect(described_class.check_authorization_header(nil)).to be_falsy
    end
  end

  describe '#check_token' do
    it 'should return false if the token is altered' do
      old_token_body = JSON.parse(Base64.decode64(@token.split('.')[1]))
      # Decode the token
      old_token_body['client_id'] = 'testing_changed'
      # Change a variable
      new_token_body = Base64.encode64(old_token_body.to_s)
      # ReEncode it
      @token.gsub!(@token.split('.')[1], new_token_body.to_s)
      # Replace the old body part of the jwt with the new one
      expect(described_class.check_token(@token)).to be_falsy
      # Should be invalid as it was not created with the secret
    end
  end

  describe '#decode_token' do
    it 'should decode the whole token' do
      decoded_token = described_class.decode_token(token: @token).to_s
      expect(decoded_token).to include('client_id')
      expect(decoded_token).to include(ENV['JWT_CLIENT_ID'])
      expect(decoded_token).to include('exp')
    end

    it 'should decode only the specified key' do
      expect(described_class.decode_token(token: @token, key: 'client_id')).to eq(ENV['JWT_CLIENT_ID'])
    end
  end

  describe 'ENV vars' do
    it 'should return false on all the public methods if any env var is not set' do
      ENV['JWT_SECRETS'] = nil
      expect(described_class.tokenify).to be_falsy
      expect(described_class.check_token(@token)).to be_falsy
      expect(described_class.decode_token(token: @token)).to eq(nil)
    end
  end
end
