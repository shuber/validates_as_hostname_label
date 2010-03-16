# Adds ActiveRecord validation for hostname labels
module ValidatesAsHostnameLabel

  # A hash of default options to use when calling <tt>validates_as_hostname_label</tt>.
  #
  # Defaults:
  #
  #   :allow_underscores  =>  false
  #   :reserved           =>  %w(admin blog dev development ftp help imap mail pop pop3 sftp smtp staging stats status support www)
  def self.default_options
    @default_options ||= {
      :allow_underscores => false,
      :reserved => %w(admin blog dev development ftp help imap mail pop pop3 sftp smtp staging stats status support www)
    }
  end
  
  # Validates hostname labels by checking for:
  #
  #   * Length between 1 and 63 characters long
  #   * Letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen (and optionally the underscore)
  #   * Labels that don't begin or end with a hyphen or underscore
  #   * Reserved hostname labels
  #
  # Options:
  #
  #   :allow_underscores  -  Allows underscores in hostname labels. Defaults to false.
  #   :reserved           -  Contains an array of reserved hostname labels to validate exclusion of. 
  #                          Defaults to ValidatesAsHostnameLabel.default_options[:reserved]
  def validates_as_hostname_label(*attrs)
    options = ValidatesAsHostnameLabel.default_options.merge(attrs.extract_options!)

    format, characters = 'a-z0-9\-', %w(alphanumeric hyphen)
    format << '_' and characters << 'underscore' if options.delete(:allow_underscores)

    I18n.with_options :scope => 'validates_as_hostname_label' do |i18n|
      validates_exclusion_of *attrs + [{
        :in => options.delete(:reserved),
        :message => i18n.t('reserved', :default => 'is reserved')
      }.merge(options)]

      validates_format_of *attrs + [{ 
        :with => /^[#{format}]*$/i,
        :message => i18n.t('invalid_format', :default => "may only contain #{characters.to_sentence} characters")
      }.merge(options)]

      validates_format_of *attrs + [{
        :with => /^[^-_].*[^-_]$/i,
        :message => i18n.t('invalid_prefix_or_suffix', :default => "may not start or end with a hyphen or underscore")
      }.merge(options)]

      validates_length_of *attrs + [{
        :in => 1..63,
        :message => i18n.t('invalid_length', :default => 'must be between 1 and 63 characters long')
      }.merge(options)]
    end
  end
end

ActiveRecord::Base.extend ValidatesAsHostnameLabel