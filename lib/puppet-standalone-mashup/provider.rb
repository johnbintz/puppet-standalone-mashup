class PuppetStandaloneMashup::Provider
  def self.shared_sources
    @shared_sources ||= []
  end

  def self.inherited(klass)
    shared_sources << Pathname(caller.first.gsub(%r{lib/.*}, ''))
  end

  def self.paths_for(*paths)
    shared_sources.collect do |source|
      paths.collect { |path| source.join(path) }
    end.flatten
  end
end
