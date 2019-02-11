require 'mumsnet_jwt'
token_arry = []
ENV['JWT_SECRETS'] = '[{"client_id": "testing", "secret": "12345"}]'
ENV['JWT_CLIENT_ID'] = 'testing'
100.times do |i|
  Thread.new do
    token = MumsnetJWT.tokenify(extra_payload:{uuid:i})
    decoded_token = MumsnetJWT.decode_token(token: token).to_s
    token_arry << token if decoded_token.include?("uuid\"=>#{i}")
  end

  Thread.new do
    token = MumsnetJWT.tokenify(extra_payload:{uuid:"2#{i}"})
    decoded_token = MumsnetJWT.decode_token(token: token).to_s
    sleep(0.1)
    token_arry << token if decoded_token.include?("uuid\"=>\"2#{i}")
  end

  Thread.new do
    token = MumsnetJWT.tokenify(extra_payload:{uuid:"3#{i}"})
    decoded_token = MumsnetJWT.decode_token(token: token).to_s
    sleep(0.1)
    token_arry << token if decoded_token.include?("uuid\"=>\"3#{i}")
  end
end
sleep(3)
if token_arry.uniq.length != token_arry.length || token_arry.length != 300
  puts 'houston we have a problem'
else
  puts 'We have lift off'
end
