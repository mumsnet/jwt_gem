Gem::Specification.new do |s|
  s.name = 'mumsnet_jwt'
  s.version = '2.1.3'
  s.date = '2018-07-11'
  s.summary = 'JSON web token lib'
  s.authors = ['Murray Catto']
  s.files = [
    'lib/mumsnet_jwt.rb'
  ]
  s.require_paths = ['lib']
  s.add_dependency 'jwt', '>= 1.5'
end
