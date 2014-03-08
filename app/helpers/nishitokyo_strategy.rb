module NishitokyoStrategy
  include LogInterceptor

  def crawl
    construct_books( make_book_strings(get_mechanize_res) )
  end

  def get_mechanize_res
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    search_page = agent.get 'http://www.library.city.nishitokyo.lg.jp/detailsearch?1'
    form = search_page.form
    if(year.blank?)
      year = Time.now.year
    elsif
      year = year.to_i
    end
    form.field_with(:name=>'textKey1').value = title.to_s
    form.field_with(:name=>'textKey2').value = author.to_s
    form.field_with(:name=>'textKey3').value = publisher.to_s
    form.field_with(:name=>'textYearFrom').value = (year - 1).to_s
    form.field_with(:name=>'textYearTo').value = (year + 1).to_s
    form.field_with(:name=>'selectMaxView').value = "100"
    form.click_button
  end

  def make_book_strings(mechanize_res)
    book_strings = []
    mechanize_res.search("tr").each do |tr|
      tr.search("img").each do |img|
        book_strings << img.attribute("alt").value
      end
    end
    book_strings
  end

  def construct_books(book_strings)
    book_strings.map do |str|
      Book.new(:title=>str)
    end
  end

end