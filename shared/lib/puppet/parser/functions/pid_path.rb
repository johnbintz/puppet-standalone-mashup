require 'puppet/modules/common_directories'

module Puppet::Parser::Functions
  newfunction(:pid_path, :type => :rvalue) do |args|
    pid_path(lookupvar('::base::pid_path'), *args)
  end
end

