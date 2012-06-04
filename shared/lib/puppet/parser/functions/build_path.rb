require 'puppet/modules/common_directories'

module Puppet::Parser::Functions
  newfunction(:build_path, :type => :rvalue) do |args|
    build_path(lookupvar('::base::src_path'), *args)
  end
end

