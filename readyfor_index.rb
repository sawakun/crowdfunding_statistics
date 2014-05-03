# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


p "title, page_address, status, meter, total, finish_date"

# スクレイピング先のURL
base_url = 'https://readyfor.jp/projects/successful?page='

for num in 1..54 do 

  url = base_url + num.to_s
  row = url
  #  p row

  begin
    doc = Nokogiri::HTML(open(url))
  rescue
    row << ", page not found"
  else

    doc.search(".project-card").each do |card|
      # title
      row = card.search("h2").search("a" ).text.strip
      # page_address
      row << "," + card.search("h2").search("a" ).attribute("href").value

      # status
      row << "," + card.search(".project-finished").text.strip

      stats = card.search(".project-stats").search("li")
      # meter
      row << "," + stats[0].search("strong").text.strip
      # total
      row << "," + stats[1].search("strong").text.gsub(',','').gsub('円','').strip
      # finish_date
      row << "," + stats[2].search(".num").text.strip

      p row
    end
  ensure
  end
end

