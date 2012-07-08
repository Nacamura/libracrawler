class Library < ActiveRecord::Base
  has_many :books
  attr_accessible :author, :name, :publisher, :title, :year
  attr_accessor :sendmail

  def check_new_book
    new_books = find_new_books(crawl_library(self))
    register(new_books)
  end

  def crawl_library(library)
    LibrariesHelper.get_crawl_strategy(name).crawl(library)
  end

  def find_new_books(crawled_books)
    crawled_books.delete_if {|cb| books.include? cb}
  end

  def register(new_books)
    unless new_books.empty?
      books.concat new_books
      notify(new_books) if sendmail
    end
  end

  def notify(new_books)
    Notifier.notify_new_book(new_books).deliver
  end

end
