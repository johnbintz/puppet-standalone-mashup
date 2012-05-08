module Puppet
  module Modules
    module CommonDirectories
      def build_path(src_path, name, version)
        File.join(src_path, "#{name}-#{version}")
      end

      def install_path(install_path, name, version)
        File.join(install_path, "#{name}-#{version}")
      end

      def symlink_path(install_path, name)
        File.join(install_path, name)
      end

      def bin_path(install_path, name)
        File.join(install_path, name, 'bin')
      end

      def sbin_path(install_path, name)
        File.join(install_path, name, 'sbin')
      end

      def pid_path(pid_path, name)
        File.join(pid_path, "#{name}.pid")
      end

      def share_path(share_path, name)
        File.join(share_path, name)
      end

      def data_path(data_path, name)
        File.join(data_path, name)
      end
    end
  end
end

class Puppet::Parser::Scope
  include Puppet::Modules::CommonDirectories
end

