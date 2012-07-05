module Puppet::Parser::Functions
  newfunction(:dir_size, :type => :rvalue) do |path|
    %x{df -m #{path}}.lines.to_a.last.strip.split(/ +/)[1].to_i / 4
  end
end

