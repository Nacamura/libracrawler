# -*- encoding: utf-8 -*-
class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def notify_new_book(books)
    @books = books
    mail(:to => EMAIL_RECIPIENTS, :subject => "新しい本が登録されました")
  end

end
