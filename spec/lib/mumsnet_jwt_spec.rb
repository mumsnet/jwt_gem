RSpec.describe MumsnetJWT do
  describe '#tokenify' do
    ENV['JWT_SECRETS'] = '[{"client_id": "testing","secret": "12345"}]'
    ENV['JWT_CLIENT_ID'] = 'testing'
    ENV['JWT_ISSUER'] = 'testing'
    it 'should generate a valid jwt token' do
      token = described_class.tokenify
      expect(token.split('.').count).to be(3)
      # Valid jwt tokens have 3 .'s
      expect(Base64.decode64(token.split('.')[1])).to include(ENV['JWT_CLIENT_ID'])
      # Expect the token to have the Client id
      expect(described_class.check_token(token)).to be_truthy
    end

    it 'should validate a Bearer Authentication header' do
      token = described_class.tokenify
      expect(described_class.check_authorization_header("Bearer #{token}")).to be_truthy
      # Used for as Authentication header
    end

    it 'should throw an error if the token is altered' do
      token = described_class.tokenify
      old_token_body = JSON.parse(Base64.decode64(token.split('.')[1]))
      # Decode the token
      old_token_body['client_id'] = 'testing_changed'
      # Change a variable
      new_token_body = Base64.encode64(old_token_body.to_s)
      # ReEncode it
      token.gsub!(token.split('.')[1], new_token_body.to_s)
      # Replace the old body part of the jwt with the new one
      expect(described_class.check_token(token)).to be_falsy
      # Should be invalid as it was not created with the secret
    end

  end
end
