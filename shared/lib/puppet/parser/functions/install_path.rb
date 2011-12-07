require 'puppet/modules/common_directories'

module Puppet::Parser::Functions
  newfunction(:install_path, :type => :rvalue) do |args|
    install_path(lookupvar('base::install_path'), *args)
  end
end

