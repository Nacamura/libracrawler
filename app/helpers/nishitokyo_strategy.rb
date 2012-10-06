module NishitokyoStrategy
  include LogInterceptor

  def crawl
    parse_to_books(get_html)
  end

  def get_html
    RestClient.post('http://www.library.city.nishitokyo.lg.jp/cgi-bin/search',
                    :referer=>"http://www.library.city.nishitokyo.lg.jp/search.shtml",
                    "ITEM1"=>"AB", "KEY1"=>title.to_s.encode('Shift_JIS'), "COMP1"=>"3",
                    "ITEM2"=>"CD", "KEY2"=>author.to_s.encode('Shift_JIS'), "COMP2"=>"3",
                    "ITEM3"=>"EF", "KEY3"=>publisher.to_s.encode('Shift_JIS'), "COMP3"=>"3",
                    "COND"=>"1", "SORT"=>"1", "YEARFROM"=>year.to_s.encode('Shift_JIS'),
                    "YEARTO"=>year.to_s.encode('Shift_JIS'),
                    "MAXVIEW"=>"300").encode('UTF-8', 'Shift_JIS',
                    :invalid => :replace, :undef => :replace)
  end

  def parse_to_books(html)
    crawled_books = []
    doc = Hpricot html
    (doc/'tr').each do |tr|
      if( (tr/'td').inner_html=='' )
        next
      end
      book_attr = []
      (tr/'td').each_with_index do |td, index|
        if(index < 2)
          next
        end
        a_content = (td/'a').inner_html
        book_attr << ( (a_content=='') ? td.inner_html : a_content )
      end
      b = Book.new(:title=>book_attr[0],:author=>book_attr[1],
                   :publisher=>book_attr[2],:year=>book_attr[3])
      crawled_books << b
    end
    crawled_books
  end

end
