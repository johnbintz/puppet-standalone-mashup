require 'delegate'

class Pathname
  def only_valid_paths_for_directories(*dirs)
    valid_paths = []

    dirs.flatten.each do |dir|
      target = self.join(dir)

      if target.directory?
        valid_paths << target
      end
    end

    valid_paths
  end
end

module PuppetStandaloneMashup
  class TargetedPath < SimpleDelegator
    attr_reader :path, :target

    def initialize(path, target = path.basename)
      @path, @target = path, target
    end

    def __getobj__
      @path
    end
  end

  class Configuration
    SHARED_DIRS = %w{lib modules templates}

    def additional_modules
      @additional_modules ||= []
    end

    def bin_path
      @bin_path ||= []
    end

    def shared_paths
      return @shared_paths if @shared_paths

      @shared_paths = []

      Provider.paths_for('shared').each do |path|
        @shared_paths += path.only_valid_paths_for_directories(SHARED_DIRS).collect { |dirpath| TargetedPath.new(dirpath) }
      end

      Provider.paths_for('additional-modules').each do |path|
        @shared_paths += path.only_valid_paths_for_directories(additional_modules).collect { |dirpath| TargetedPath.new(dirpath, "modules/#{dirpath.basename}") }
      end

      @shared_paths
    end
  end
end

