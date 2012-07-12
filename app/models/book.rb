class Book < ActiveRecord::Base
  belongs_to :library
  attr_accessible :author, :publisher, :title, :year

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

end
