Puppet::Type.newtype(:make_and_install) do
  @doc = "Make and install a program"

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
    desc "Binary path to add"
  end

  newparam(:unless) do
    desc "If provided, don't run the make and install unless this condition is true"
  end
end

