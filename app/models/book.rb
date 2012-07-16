# -*- encoding: utf-8 -*-
class Book < ActiveRecord::Base
  belongs_to :library
  attr_accessible :author, :publisher, :title, :year, :release

  def ==(other)
    if(other.instance_of? self.class)
      if(other.title == self.title)
        if(other.author == self.author)
          if(other.publisher == self.publisher)
            if(other.year == self.year)
              return true
            end
          end
        end
      end
    end
    return false
  end

  def eql?(other)
    self == other
  end

  def ===(other)
    if(matches?(self.title, other.title))
      if(matches?(self.author, other.author))
        if(matches?(self.publisher, other.publisher))
          return true
        end
      end
    end
    return false
  end

  def matches?(book_attr, keyword)
    book_attr ||= ''
    (keyword.nil? || keyword=='') || (book_attr.gsub(/(\s|　)/, '').include? keyword.gsub(/(\s|　)/, ''))
  end 

end
