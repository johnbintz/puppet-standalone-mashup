module Puppet::Parser::Functions
  newfunction(:find_path, :type => :rvalue) do |name, root|
    Pathname(root).find do |file|
      return file.to_s if file.basename == name
    end

    raise StandardError.new("File not found in #{root}: #{name}")
  end
end

