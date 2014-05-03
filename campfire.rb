# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


p "url, title, owner, category, category_url, updates, status, total, meter, target, patron, rest, pref"

# スクレイピング先のURL
base_url = 'http://camp-fire.jp/projects/view/'


for num in 2..1001 do 

  url = base_url + num.to_s
  row = url

  begin
    doc = Nokogiri::HTML(open(url))
  rescue
    row << ", page not found"
  else

    # title
    row << "," + doc.search('h1').text

    subtitle_list = doc.search(".subtitle").search("li")
    # owner
    row << "," + subtitle_list[1].text
    # category
    row << "," + subtitle_list[2].text
    # category_url
    row << "," + subtitle_list[2].search("a").attribute("href").value

    menu_list = doc.search(".menu").search("li")
    # updates
    row << "," + menu_list[1].search("span").text

    # status
    row << "," + doc.search(".status").search("p").text

    total = doc.search(".total")
    # total
    row << "," + total.xpath('strong[@class="number"]').text.gsub(',', '').gsub('円', '')
    # meter
    row << "," + total.xpath('div[@class="meter"]').xpath('.//span').text
    # target
    row << "," + total.xpath('div[@class="target"]').text.gsub(',', '').gsub('円', '').gsub('目標金額は', '')  

    # patron
    row << "," + doc.search(".patron").xpath('strong[@class="number"]').text.gsub('人', '') 

    # rest
    row << "," + doc.search(".rest").xpath('strong[@class="number"]').text

    # username
    #row << "," +  doc.search(".username").text
    # pref
    pref = doc.search(".pref").search("li")
    row << "," + pref.first.text unless pref.size == 0
  ensure
    p row
  end

end
