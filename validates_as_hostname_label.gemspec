Gem::Specification.new do |s|
  s.name    = 'validates_as_hostname_label'
  s.version = '1.0.0'
  s.date    = '2009-01-13'
  
  s.summary     = 'Ensures arguments are valid hostname labels'
  s.description = 'Ensures arguments are valid hostname labels'
  
  s.author   = 'Sean Huber'
  s.email    = 'shuber@huberry.com'
  s.homepage = 'http://github.com/shuber/validates_as_hostname_label'
  
  s.has_rdoc = false
  
  s.files = %w(
    CHANGELOG
    init.rb
    lib/validates_as_hostname_label.rb
    MIT-LICENSE
    Rakefile
    README.markdown
  )
  
  s.test_files = %w(
    test/validates_as_hostname_label_test.rb
  )
end