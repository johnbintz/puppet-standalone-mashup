Puppet::Type.newtype(:god_init) do
  @doc = "A God configuration"

  ensurable

  newparam(:name) do
    desc "The name of the process"
  end

  newparam(:start) do
    desc "The command to start the process"
  end

  newparam(:stop) do
    desc "The command to stop the process"
  end

  newparam(:restart) do
    desc "The command to restart/reload the process"
  end

  newparam(:dir) do
    desc "The directory where god configs are held"
  end

  newparam(:pid_file) do
    desc "A pid file"
  end

  newparam(:interval) do
    desc "The check interval"
  end
end

