Gem::Specification.new do |s|
  s.name        = 'fusion_tables_v2'
  s.version     = '0.0.1'
  s.date        = '2015-07-29'
  s.summary     = 'Fusion Tables API wrapper'
  s.description = 'This gem adding methods to interact with Fusion Tables like DB'
  s.authors     = ['Rozenkin Denis']
  s.email       = 'rozenkin@gmail.com'
  s.files       = ['lib/fusion_tables_v2.rb']
  s.homepage    = 'http://rubygems.org/gems/fusion_tables_v2'
  s.license     = 'MIT'
  s.add_dependency 'google-api-client', '0.9.pre2'
  s.add_development_dependency 'pry'
end
