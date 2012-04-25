Before do
  # thanks dave. thave.
  @sugarpuck = {
    :username => 'vagrant',
    :password => 'vagrant',
    :port => 2222
  }
end

require 'puppet-standalone-mashup/cucumber/via_ssh'
require 'puppet-standalone-mashup/cucumber/vagrant'

