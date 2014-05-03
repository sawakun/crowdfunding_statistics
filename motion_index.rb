# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


p "title, page_address, owner, category, status, patron, total, rest"

# スクレイピング先のURL
base_url = 'https://motion-gallery.net/projects?page='

for num in 1..33 do 

  url = base_url + num.to_s
  row = url
  #  p row

  begin
    doc = Nokogiri::HTML(open(url),nil,"utf-8")
  rescue
    row << ", page not found"
  else

    doc.search(".pjtItem").each do |project|
      # title
      row = project.search(".pjtTitle").search("a" ).text.strip
      # page_address
      row << "," + project.search(".pjtTitle").search("a").attribute("href").value

      # owner
      row << "," + project.css("li.presenter").search("a").text.strip

      # category
      row << "," + project.css("p.categoryTagLabel").search("a").text.strip

      # status
      row << "," + project.css("div.progress").search("p").text.strip

      status = project.css("ul.pjtStatus").search("li")
      if status.size > 0 then
        # patron
        row << "," + status[0].search("span").text

        # total
        row << "," + status[1].search("span").text.gsub(',','')

        # rest
        row << "," + status[2].text
      else
      end

      p row
    end
  ensure
  end
end

