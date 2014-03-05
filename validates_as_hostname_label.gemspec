Gem::Specification.new do |s|
  s.name    = 'validates_as_hostname_label'
  s.version = '1.1.1'
  s.date    = '2010-03-16'

  s.summary     = 'Checks for valid hostname labels'
  s.description = 'Checks for valid hostname labels'

  s.author   = 'Sean Huber'
  s.email    = 'shuber@huberry.com'
  s.homepage = 'http://github.com/shuber/validates_as_hostname_label'

  s.has_rdoc = false

  s.files = %w(
    init.rb
    lib/validates_as_hostname_label.rb
    Gemfile
    Gemfile.lock
    MIT-LICENSE
    Rakefile
    README.rdoc
    test/validates_as_hostname_label_test.rb
  )

  s.test_files = %w(
    test/validates_as_hostname_label_test.rb
  )

  s.add_dependency 'activerecord'
  s.add_development_dependency 'sqlite3'
end
