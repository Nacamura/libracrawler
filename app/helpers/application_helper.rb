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
        define_method(m) {
          Rails.logger.info "#{m}: start at #{start=Time.now}"
          self.send(original)
          Rails.logger.info "#{m}: stop  at #{stop=Time.now}, elapsed: #{stop-start}"
        }
      end
    end
  end

end
