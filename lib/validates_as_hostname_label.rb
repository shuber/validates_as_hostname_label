module Huberry
  module ValidatesAsHostnameLabel
    # Checks for:
    #
    #   * Length between 1 and 63 characters long
    #   * Letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen (and optionally the underscore)
    #   * Labels that don't begin or end with a hyphen or underscore
    #
    # Accepts an :allow_underscores option which defaults to false
    def validates_as_hostname_label(*attrs)
      configuration = attrs.last.is_a?(Hash) ? attrs.pop : {}
      
      format = 'a-z0-9-'
      format << '_' if configuration.delete(:allow_underscores)
      
      validates_length_of *attrs.push({ :in => 1..63, :message => 'must be between 1 and 63 characters long' })
      validates_format_of *attrs.push({ :with => /^[#{format}]*$/i }.merge(configuration))
      validates_format_of *attrs.push({ :with => /^[^-_].*[^-_]$/i, :message => "can't start or end with a hyphen or underscore" })
    end
  end
end

ActiveRecord::Base.extend Huberry::ValidatesAsHostnameLabel