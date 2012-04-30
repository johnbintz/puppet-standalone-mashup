require 'puppet/modules/common_directories'

module Puppet::Parser::Functions
  newfunction(:bin_path, :type => :rvalue) do |args|
    $stdout.puts args.inspect

    bin_path(lookupvar('base::install_path'), *args)
  end
end


