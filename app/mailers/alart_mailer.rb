# -*- encoding: utf-8 -*-
class AlartMailer < ActionMailer::Base
  default from: "from@example.com"

  def alart_mail(log)
    @log = log
    mail(:to => EMAIL_RECIPIENTS, :subject => "クローリングエラー発生")
  end

end
