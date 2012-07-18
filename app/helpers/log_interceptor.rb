module LogInterceptor

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def method_added(m)
      log_around_invoke(m)
    end

    def log_around_invoke(m)
      return if not (LOGGING_METHODS.include? m)
      original = m.to_s + '_original'
      return if method_defined? original
      alias_method original, m
      define_method(m) { |*args, &block|
        Rails.logger.info "#{m}: start at #{start=Time.now}"
        return_value = self.send(original, *args, &block)
        Rails.logger.info "#{m}: stop  at #{stop=Time.now}, elapsed: #{stop-start}"
        return_value
      }
    end

  end

end
