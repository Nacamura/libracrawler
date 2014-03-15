module NishitokyoStrategy
  include LogInterceptor

  NO_LINK = "現在利用できません。リクエストについては図書館に直接ご相談ください。"

  def crawl
    make_books(get_mechanize_res)
  end

  def get_mechanize_res
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    search_page = agent.get 'http://www.library.city.nishitokyo.lg.jp/detailsearch?1'
    form = search_page.form
    if(self.year.blank?)
      self.year = Time.now.year
    end
    form.field_with(:name=>'textKey1').value = title.to_s
    form.field_with(:name=>'textKey2').value = author.to_s
    form.field_with(:name=>'textKey3').value = publisher.to_s
    form.field_with(:name=>'textYearFrom').value = (self.year - 1).to_s
    form.field_with(:name=>'textYearTo').value = (self.year + 1).to_s
    form.field_with(:name=>'selectMaxView').value = "100"
    form.click_button
  end

  def make_books(mechanize_res)
    hit_count = mechanize_res.search("p")[2].search("span")[1].text.gsub(/件中.*/, "").to_i
    if(hit_count > 100)
      AlartMailer.alart_mail(self.to_s + " 検索件数が#{hit_count}件です。100件目以降は通知されません。").deliver
    end
    books = []
    mechanize_res.search("tr").each do |tr|
      dds = tr.search("dd")
      if(dds.length < 3) then next end
      if(dds[-1].text == NO_LINK) then next end
      img = tr.search("img")
      if(img.length == 0) then next end
      year = dds[1].text
      author = dds[2].text
      publisher = dds[-1].text
      title = img.attribute("alt").value
      books << Book.new(:title=>title, :author=>author, :publisher=>publisher, :year=>year)
    end
    books
  end

end