require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/validates_as_hostname_label'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

class Account < ActiveRecord::Base
  validates_as_hostname_label :subdomain
  validates_as_hostname_label :subdomain_with_underscores, :allow_underscores => true
end

class ValidatesAsHostnameLabelTest < Test::Unit::TestCase
  
  def setup
    ActiveRecord::Base.connection.tables.each { |table| ActiveRecord::Base.connection.drop_table(table) }
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :accounts do |t|
          t.string   :subdomain
          t.string   :subdomain_with_underscores
        end
      end
    end
  end
  
  def test_should_save_with_valid_subdomains
    @account = Account.new :subdomain => 'test', :subdomain_with_underscores => 'test'
    assert @account.save
  end
  
  def test_should_save_subdomains_with_hyphens
    @account = Account.new :subdomain => 'test-ing', :subdomain_with_underscores => 'test-ing'
    assert @account.save
  end
  
  def test_should_not_save_with_blank_subdomain
    @account = Account.new :subdomain => nil
    assert !@account.save
    assert @account.errors.on(:subdomain)
    
    @account.subdomain = ''
    assert !@account.save
    assert @account.errors.on(:subdomain)
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
    @account = Account.new :subdomain => '-test'
    @account.subdomain_with_underscores = '_test'
    assert !@account.save
    assert @account.errors.on(:subdomain)
    assert @account.errors.on(:subdomain_with_underscores)
  end
  
  def test_should_not_save_with_subdomains_ending_with_a_hyphen_or_underscore
    @account = Account.new :subdomain => 'test-'
    @account.subdomain_with_underscores = 'test_'
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
    @account = Account.new :subdomain => 'test', :subdomain_with_underscores => 'test_ing'
    assert @account.save
  end
  
end