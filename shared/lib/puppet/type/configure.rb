Puppet::Type.newtype(:configure) do
  @doc = "Configuring a program to install"

  ensurable

  newparam(:name) do
    desc "The name of the program"
  end

  newparam(:build_path) do
    desc "The location of downloaded sources"
  end

  newparam(:install_path) do
    desc "The location to install builds"
  end

  newparam(:options) do
    desc "Options to build the software"
  end

  newparam(:preconfigure) do
    desc "Options to go before the configure command, like environment variables"
  end

  newparam(:config_status) do
    desc "Relative location of config.status"
  end

  newparam(:path) do
    desc "Path for executables"
  end

  newparam(:unless) do
    desc "If provided, don't run the configure unless this condition is true"
  end
end

