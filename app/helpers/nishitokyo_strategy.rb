module NishitokyoStrategy
  include LogInterceptor

  def crawl
    make_books(get_mechanize_res)
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

  def make_books(mechanize_res)
    books = []
    mechanize_res.search("tr").each do |tr|
      dds = tr.search("dd")
      if dds.length < 3 then next end
      img = tr.search("img")
      if img.length == 0 then next end
      year = dds[1].text
      author = dds[2].text
      publisher = dds[-1].text
      title = img.attribute("alt").value
      books << Book.new(:title=>title, :author=>author, :publisher=>publisher, :year=>year)
    end
    books
  end

end