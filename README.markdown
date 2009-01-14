# validates\_as\_hostname\_label #

Checks for valid hostname labels by looking for:

  * Length between 1 and 63 characters long  
  * Letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen (and optionally the underscore)  
  * Labels that don't begin or end with a hyphen or underscore  

See [http://en.wikipedia.org/wiki/Hostname#Restrictions\_on\_valid\_host\_names](http://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names)


## Installation ##

	gem install shuber-validates_as_hostname_label --source http://gems.github.com
	OR
	script/plugin install git://github.com/shuber/validates_as_hostname_label.git


## Usage ##

	class Account < ActiveRecord::Base
	  validates_as_hostname_label :subdomain
	end

Also accepts an `:allow_underscores` option which defaults to `false`

The usual validation options (like `:if`, `:unless`, `:allow_nil`, etc) work as well


## Contact ##

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)