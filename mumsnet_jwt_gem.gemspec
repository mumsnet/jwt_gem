Gem::Specification.new do |s|
  s.name = 'mumsnet_jwt'
  s.version = '2.0.7'
  s.date = '2018-07-11'
  s.summary = 'JSON web token lib'
  s.authors = ['Murray Catto']
  s.files = [
    'lib/mumsnet_jwt.rb'
  ]
  s.require_paths = ['lib']
  s.add_dependency 'jwt'
end
