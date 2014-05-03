# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


p "title, page_address, curated_page, category, owner, rest, patron, meter, total"

# スクレイピング先のURL
base_url = 'https://greenfunding.jp/portals/search?page='

for num in 1..17 do 

  url = base_url + num.to_s
  row = url
  #  p row

  begin
    doc = Nokogiri::HTML(open(url),nil,"utf-8")
  rescue
    row << ", page not found"
  else

    doc.search(".project").each do |project|
      # title
      row = project.search(".project-content").search("h2").search("a" ).text.strip
      # page_address
      row << "," + project.search("h2").search("a" ).attribute("href").value
      # curated_page
      row << "," + project.search(".project-curated-page").search("a").text

      # category
      row << "," + project.search(".category").search("a").text.strip

      # owner
      row << "," + project.search(".ownername").search("a").text.strip

      # finish_date
      footer = project.search(".box-footer").search("h3")
      if footer.size > 0 then
        # rest
        row << "," + footer[0].text
        # patron
        row << "," + footer[1].text
        # meter
        row << "," + project.css("h2.progress").search("span").text 
        # total
        row << "," + project.css("h2.gathered").text.gsub('¥','').gsub(',','')
      else
      end

      p row
    end
  ensure
  end
end

