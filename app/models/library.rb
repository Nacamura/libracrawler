class Library < ActiveRecord::Base
  has_many :books
  attr_accessible :author, :name, :publisher, :title, :year
  attr_accessor :sendmail
  validates :name, :presence => true, :inclusion => {:in => LIBRARY_NAMES}

  def check_new_book
    new_books = find_new_books(crawl_library)
    register(new_books)
  end

  def crawl_library
    extend(STRATEGY_MAPPING[name]).crawl
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
