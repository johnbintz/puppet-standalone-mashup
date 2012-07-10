Puppet::Type.newtype(:god_init) do
  @doc = "A God configuration"

  ensurable

  newparam(:name) do
    desc "The name of the process"
  end

  newparam(:start) do
    desc "The command to start the process"
  end

  newparam(:group) do
    desc "The group this process belongs to"
  end

  newparam(:dir) do
    desc "The directory where god configs are held"
  end

  newparam(:interval) do
    desc "The check interval"
  end
end

