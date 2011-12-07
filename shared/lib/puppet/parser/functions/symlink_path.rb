require 'puppet/modules/common_directories'

module Puppet::Parser::Functions
  newfunction(:symlink_path, :type => :rvalue) do |args|
    symlink_path(lookupvar('base::install_path'), *args)
  end
end

