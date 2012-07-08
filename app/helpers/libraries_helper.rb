module LibrariesHelper
  module_function

  def get_crawl_strategy(name)
    STRATEGY_MAPPING[name]
  end

end
