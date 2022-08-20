Gem::Specification.new do |s|
  s.name        = "tcmb_exchanger"
  s.version     = "1.0.0"
  s.summary     = "The exchange calculator which is get exchange rates over TCMB daily exchange link."
  s.description = "Currency calculator that receives exchange rates through the TCMB daily foreign exchange connection. Exchange rates can be called as functions or hash value."
  s.authors     = ['tayak']
  s.email       = 'yasir.kiroglu@gmail.com'
  s.files       = ['lib/tcmb_exchanger.rb']
  s.homepage    = "https://github.com/taiak/tcmb_exchanger"
  s.license     = "Apache-2.0"
  s.add_runtime_dependency 'crack',    '~> 0.4.5'
  s.add_runtime_dependency 'ostruct',  '~> 0.3.1'
  s.add_runtime_dependency 'json',     '~> 2.5.1'
  s.add_runtime_dependency 'net-http', '~> 0.1.1'
end