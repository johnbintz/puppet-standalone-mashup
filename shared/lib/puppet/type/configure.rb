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

  newparam(:path) do
    desc "Path for executables"
  end
end

