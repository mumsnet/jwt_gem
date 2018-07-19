# Mumsnet JWT Gem
![Shiny](https://media.giphy.com/media/3oEdv6thH4aJHVcs6c/giphy.gif)


This gem will be used for all api jwt token creation and verification

## Installation

Please add to your gem file:
```
gem 'mumsnet_jwt', git: "https://github.com/mumsnet/jwt_gem"
```

## Requirements
The following Enviromental Variables Must be defined in order to use this gem.
The JWT_SECERET variable must be the same as all the other services.
ENV['API_ACCESS_TOKEN']
ENV['JWT_ISSUER']
ENV['JWT_SECERET']

## Usage

So the gem it's self is very basic but it needs to be a gem as it will be reused across our API projects.

Generating a basic token:

```ruby
MumsnetJWT.tokenify
# => "eyJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3NfdG9rZW4iOiJkNmI3YmYwODE3NWZmOWQ5MjhiYmYxOTVmODEyYjc5ZDEzZDdkNmRhIiwiaXNzIjoiTXVtc25ldCBMaW1pdGVkIiwiZXhwIjoxNTMxNDc4MjI3fQ.Jxe_V3GbRnmg4uE1xtaBZkJodldr1OoQgRLRwEz0dpQ"

```
Generating a token with extra variables:

```ruby
MumsnetJWT.tokenify(extra_payload: {user_id: 1})
```
Checking if a token is valid:

```ruby
token = MumsnetJWT.tokenify
MumsnetJWT.check_token(token)
# => true
MumsnetJWT.check_token("#{token}1")
# => false
```

Retriving extra data:
```ruby
token = MumsnetJWT.tokenify(extra_payload: {user_id: 1})
user_id = MumsnetJWT.decode_token(token: token, key: user_id)
# => 1
```

API Usage:
in a ` before_action :check_token` in your base api controller add a method like so
```ruby
def check_token
  head :unauthorized, content_type: 'text/html' unless MumsnetJWT.check_token(request.headers['token'])
end
```

If you have a before action for a user specific function such as update_account you would need to use a before action like this:

```ruby
def set_user_via_token
  @user = User.find(MumsnetJWT.decode_token(token: request.headers['token'], key: 'user_id'))
rescue StandardError
  head :unauthorized, content_type: 'text/html'
end
```
