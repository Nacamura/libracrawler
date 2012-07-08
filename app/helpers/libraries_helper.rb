module LibrariesHelper
  module_function

  def crawl(library)
    get_crawl_strategy(library.name).crawl(library)
  end

  def get_crawl_strategy(name)
    STRATEGY_MAPPING[name]
  end

end
