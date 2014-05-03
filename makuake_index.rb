# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


p "title, page_address, owner, category, total, meter, patron, rest"

# スクレイピング先のURL
base_url = 'https://www.makuake.com/discover/index/'
base_url_after = '/all/open/list/'

for num in 1..11 do 

  url = base_url + num.to_s + base_url_after
  row = url
  #  p row

  begin
    doc = Nokogiri::HTML(open(url),nil,"utf-8")
  rescue
    row << ", page not found"
  else

    doc.search(".projectBox").each do |project|
      # title
      row = project.search("h2").text.strip

      # page_address
      row << "," + project.search("a").first.attribute("href").value

      # owner
      row << "," + project.css("a.projectThumb").search("span").text.strip

      # category
      row << "," + project.css("a.projectTag").text.strip

      # total
      row << "," + project.css("div.projectMoney").search("dd").text.gsub(',','').gsub('円','')

      # meter
      row << "," + project.css("div.projectGageIn").search("p").text

      # patron
      row << "," + project.css("div.projectSupporter").search("dd").text

      # rest
      row << "," + project.css("div.projectTime").search("dd").text

      p row
    end
  ensure
  end
end

