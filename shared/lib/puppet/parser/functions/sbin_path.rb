require 'puppet/modules/common_directories'
module Puppet::Parser::Functions
  newfunction(:sbin_path, :type => :rvalue) do |args|
    sbin_path(lookupvar('::base::install_path'), *args)
  end
end

