Rails.logger.info "Start #{start=Time.now}"

begin
  Library.includes(:books).all.each do |lib|
    lib.sendmail = true
    lib.check_new_book
  end
rescue => ex
  AlartMailer.alart_mail(ex.message).deliver
end

Rails.logger.info "Stop #{stop=Time.now}"
Rails.logger.info "Elapsed #{stop-start}"
