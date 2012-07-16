module ApplicationHelper

  def self.included(base)
    base.extend(LogInterceptor)
  end

  module LogInterceptor
    def log_around_invoke
      instance_methods.each do |m|
        next if not (LOGGING_METHODS.include? m)
        original = m.to_s + '_original'
        alias_method original, m
        define_method(m) { |*args|
          Rails.logger.info "#{m}: start at #{start=Time.now}"
          return_value = self.send(original, *args)
          Rails.logger.info "#{m}: stop  at #{stop=Time.now}, elapsed: #{stop-start}"
          return_value
        }
      end
    end
  end

end
