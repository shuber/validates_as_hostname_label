# validates\_as\_hostname\_label #

Checks for valid hostname labels by looking for:

  * Length between 1 and 63 characters long  
  * Letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen (and optionally the underscore)  
  * Labels that don't begin or end with a hyphen or underscore  
  * Reserved labels  

See [http://en.wikipedia.org/wiki/Hostname#Restrictions\_on\_valid\_host\_names](http://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names)


## Installation ##

	gem install shuber-validates_as_hostname_label --source http://gems.github.com
	OR
	script/plugin install git://github.com/shuber/validates_as_hostname_label.git


## Usage ##

	class Account < ActiveRecord::Base
	  validates_as_hostname_label :subdomain
	end

You may optionally pass a `:reserved` option which should be an array of hostname labels to exclude

	class Account < ActiveRecord::Base
	  validates_as_hostname_label :subdomain, :reserved => ['www', 'ftp', 'mail', 'pop']
	end
	
	@account = Account.new :subdomain => 'www'
	@account.save # false
	@account.errors # { :subdomain => 'is reserved' }

Also accepts an `:allow_underscores` option which defaults to `false`

	class Account < ActiveRecord::Base
	  validates_as_hostname_label :subdomain, :allow_underscores => true
	end
	
	@account = Account.new :subdomain => 'test_ing'
	@account.save # true

The usual validation options (like `:if`, `:unless`, `:allow_nil`, etc) work as well


## Contact ##

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)