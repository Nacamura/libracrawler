class NishitokyoStrategy

  def crawl(library)
    parse_to_books(get_html(library))
  end

  def get_html(l)
    RestClient.post('http://www.library.city.nishitokyo.lg.jp/cgi-bin/search',
                    :referer=>"http://www.library.city.nishitokyo.lg.jp/search.shtml",
                    "ITEM1"=>"AB", "KEY1"=>l.title.encode('Shift_JIS'), "COMP1"=>"3",
                    "ITEM2"=>"CD", "KEY2"=>l.author.encode('Shift_JIS'), "COMP2"=>"3",
                    "ITEM3"=>"EF", "KEY3"=>l.publisher.encode('Shift_JIS'), "COMP3"=>"3",
                    "COND"=>"1", "SORT"=>"1",
                    "YEARFROM"=>l.year.to_s, "YEARTO"=>l.year.to_s,
                    "MAXVIEW"=>"300").encode('UTF-8', 'Shift_JIS')
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
        book_attr.push (a_content=='') ? td.inner_html : a_content
      end
      b = Book.new(:title=>book_attr[0],:author=>book_attr[1],
                   :publisher=>book_attr[2],:year=>book_attr[3])
      crawled_books.push b
    end
    crawled_books
  end

end
