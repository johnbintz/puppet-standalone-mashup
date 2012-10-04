require "puppet-standalone-mashup/version"

module PuppetStandaloneMashup
  autoload :Provider, 'puppet-standalone-mashup/provider'
  autoload :Configuration, 'puppet-standalone-mashup/configuration'

  class ProvideMyself < Provider ; end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.paths_for(*args)
    Provider.paths_for(*args)
  end
end
