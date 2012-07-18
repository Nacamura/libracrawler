module ComicStrategy
  include LogInterceptor

  def crawl
    parse_to_books(get_joint_html)
  end

  def get_joint_html
    get_urls.inject('') do |html, url|
      html + get_html(url)
    end
  end

  def get_html(url)
    begin
      RestClient.get(url).encode('UTF-8', 'Shift_JIS')
    rescue RestClient::ResourceNotFound
      'Resource for ' + url + ' is not found'
    end
  end

  def get_urls
    urls = []
    get_months.each do |m|
      urls << 'http://www.taiyosha.co.jp/comic/comic' + m + '_date1.html'
      urls << 'http://www.taiyosha.co.jp/comic/comic' + m + '_date2.html'
    end
    urls
  end

  def get_months
    (0..2).map{|i| Time.now.months_since(i).strftime('%y%m')}
  end

  def parse_to_books(html)
    crawled_books = []
    doc = Hpricot html
    (doc/'tr').each do |tr|
      if( (tr/'td').length != 6 )
        next
      end
      book_attr = []
      (tr/'td').each_with_index do |td, index|
        if(index > 3)
          next
        end
        book_attr << ( td.inner_html.gsub(/<.*(br|BR).*>/, '') )
      end
      b = Book.new(:release=>book_attr[0],:publisher=>book_attr[1],
                   :title=>book_attr[2],:author=>book_attr[3])
      crawled_books << b if (b === self)
    end
    crawled_books
  end

end
