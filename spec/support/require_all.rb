Kernel.module_eval do
  def require_all(path)
    $LOAD_PATH.map do |dir|
      paths = Dir["#{dir}/#{path}/**/*.rb"]
      paths = paths.map { |path| path.sub(%r((#{dir}/|#{File.extname(path)})), '') }
      paths.each { |path| require path }
    end
  end
end
