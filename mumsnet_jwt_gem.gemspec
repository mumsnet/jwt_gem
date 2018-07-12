Gem::Specification.new do |s|
  s.name = 'Mumsnet JWT'
  s.version = '0.0.1'
  s.date = '2018-07-11'
  s.summary = 'JSON web token lib'
  s.files = [
    'lib/mumsnet_jwt.rb'
  ]
  s.require_paths = ['lib']
  s.add_dependency 'jwt'
end
