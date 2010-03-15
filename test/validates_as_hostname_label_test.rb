require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/validates_as_hostname_label'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

class Account < ActiveRecord::Base
  validates_as_hostname_label :subdomain
  validates_as_hostname_label :subdomain_with_underscores, :allow_underscores => true
  validates_as_hostname_label :subdomain_with_blank, :allow_blank => true
  validates_as_hostname_label :subdomain_with_nil, :allow_nil => true
  validates_as_hostname_label :subdomain_with_reserved, :reserved => ['funky']
end

class ValidatesAsHostnameLabelTest < Test::Unit::TestCase
  
  def setup
    ActiveRecord::Base.connection.tables.each { |table| ActiveRecord::Base.connection.drop_table(table) }
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :accounts do |t|
          t.string   :subdomain
          t.string   :subdomain_with_underscores
          t.string   :subdomain_with_blank
          t.string   :subdomain_with_nil
          t.string   :subdomain_with_reserved
        end
      end
    end
  end
  
  def test_should_save_with_valid_subdomains
    @account = Account.new :subdomain => 'testing', :subdomain_with_underscores => 'testing', :subdomain_with_nil => 'testing', :subdomain_with_blank => 'testing', :subdomain_with_reserved => 'testing'
    assert @account.save
  end
  
  def test_should_save_subdomains_with_hyphens
    @account = Account.new :subdomain => 'test-ing', :subdomain_with_underscores => 'test-ing', :subdomain_with_nil => 'test-ing', :subdomain_with_blank => 'test-ing', :subdomain_with_reserved => 'test-ing'
    assert @account.save
  end
  
  def test_should_not_save_with_blank_subdomain_if_allow_option_is_not_specified
    @account = Account.new :subdomain => nil
    assert !@account.save
    assert @account.errors.on(:subdomain)
    
    @account.subdomain = ''
    assert !@account.save
    assert @account.errors.on(:subdomain)
  end
  
  def test_should_save_with_blank_subdomain
    @account = Account.new :subdomain => 'testing', :subdomain_with_underscores => 'testing', :subdomain_with_nil => 'testing', :subdomain_with_blank => '', :subdomain_with_reserved => 'testing'
    assert @account.save
  end
  
  def test_should_save_with_nil_subdomain
    @account = Account.new :subdomain => 'testing', :subdomain_with_underscores => 'testing', :subdomain_with_nil => nil, :subdomain_with_blank => 'testing', :subdomain_with_reserved => 'testing'
    assert @account.save
  end
  
  def test_should_not_save_with_too_long_of_a_subdomain
    @account = Account.new :subdomain => ('t' * 64)
    assert !@account.save
    assert @account.errors.on(:subdomain)
  end
  
  def test_should_not_save_with_invalid_characters
    @account = Account.new :subdomain => '!@#$%^&*'
    assert !@account.save
    assert @account.errors.on(:subdomain)
  end
  
  def test_should_not_save_with_subdomains_beginning_with_a_hyphen_or_underscore
    @account = Account.new :subdomain => '-testing'
    @account.subdomain_with_underscores = '_testing'
    assert !@account.save
    assert @account.errors.on(:subdomain)
    assert @account.errors.on(:subdomain_with_underscores)
  end
  
  def test_should_not_save_with_subdomains_ending_with_a_hyphen_or_underscore
    @account = Account.new :subdomain => 'testing-'
    @account.subdomain_with_underscores = 'testing_'
    assert !@account.save
    assert @account.errors.on(:subdomain)
    assert @account.errors.on(:subdomain_with_underscores)
  end
  
  def test_should_not_save_subdomains_with_an_underscore_if_allow_underscores_option_is_false
    @account = Account.new :subdomain => 'test_ing'
    assert !@account.save
    assert @account.errors.on(:subdomain)
  end
  
  def test_should_save_subdomains_with_an_underscore_if_allow_underscores_option_is_true
    @account = Account.new :subdomain => 'testing', :subdomain_with_underscores => 'test_ing', :subdomain_with_nil => 'testing', :subdomain_with_blank => 'testing', :subdomain_with_reserved => 'testing'
    assert @account.save
  end
  
  def test_should_not_save_with_a_reserved_subdomain_from_the_default_list
    ValidatesAsHostnameLabel::RESERVED_HOSTNAMES.each do |hostname|
      @account = Account.new :subdomain => hostname
      assert !@account.save
      assert @account.errors.on(:subdomain)
    end
  end

  def test_should_not_save_with_a_reserved_subdomain_from_a_list
    @account = Account.new :subdomain_with_reserved => 'funky'
    assert !@account.save
    assert @account.errors.on(:subdomain_with_reserved)
  end
  
  def test_should_not_be_valid_with_a_subdomain_not_from_the_list
    @account = Account.new :subdomain_with_reserved => 'qqqfds'
    assert !@account.save
    assert !@account.errors.on(:subdomain_with_reserved)
  end
  
end