Rails.logger.info "Begin #{Time.now}"

libs = Library.includes(:books).all
libs.each(&:check_new_book) 

Rails.logger.info "End #{Time.now}"
