# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
base_url = 'http://camp-fire.jp/projects/view/'

# escape double quotaion for CSV
def escape_double_quote (s)
  if ( /"/ =~ s )
    return '"' + s.gsub('"','""') + '"'
  else
    return '"' + s + '"'
  end
end

# get latest
fresh_url = "http://camp-fire.jp/projects/fresh"
latest = 2
begin
  doc = Nokogiri::HTML(open(fresh_url))
rescue
else
  boxes = doc.search("div.box-thumbnail")
  boxes.each do |box|
    p_id = box.search("a").first.attribute("href").value.gsub("/projects/view/","").to_i
    latest = p_id if p_id > latest
  end
ensure
end


# write header
header = ["url", "title", "owner", "category", "updates", "status", "start_date", "success_date", "close_date", "total", "meter", "target", "patron", "rest", "pref"]
puts header.inspect.gsub('[','').gsub(']','')


# main
for num in 1..latest do 

  url = base_url + num.to_s
  row = escape_double_quote(url)

  begin
    doc = Nokogiri::HTML(open(url))
  rescue
    row << "," + escape_double_quote("page not found")
  else

    # title
    row << "," + escape_double_quote(doc.search('h1').text)

    subtitle_list = doc.search(".subtitle").search("li")
    # owner
    row << "," + escape_double_quote(subtitle_list[1].text)
    # category
    row << "," + escape_double_quote(subtitle_list[2].text)
    # category_url
    #row << "," + escape_double_quote(subtitle_list[2].search("a").attribute("href").value)

    menu_list = doc.search(".menu").search("li")
    # updates
    row << "," + escape_double_quote(menu_list[1].search("span").text)

    # status (CLOSE=SUCCESSして終了、UNSUCCESS=SUCCESSせずに終了、LIVE=募集中かつまだSUCCESSしていない、SUCCESS=募集中かつSUCCESS済み)
    row << "," + escape_double_quote(doc.search("section.status").search("h5").text)
    # dates (start_date, success_date, close_date)
    dates = doc.search("section.status").search("p").text.scan(/\d{4}\/\d{2}\/\d{2}/)
    dates.insert(1, "") if dates.length == 2 
    dates.each do |date|
      row << "," + escape_double_quote(date)
    end

    total = doc.search(".total")
    # total
    row << "," + escape_double_quote(total.xpath('strong[@class="number"]').text.gsub(',', '').gsub('円', ''))
    # meter
    row << "," + escape_double_quote(total.xpath('div[@class="meter"]').xpath('.//span').text)
    # target
    row << "," + escape_double_quote(total.xpath('div[@class="target"]').text.gsub(',', '').gsub('円', '').gsub('目標金額は', ''))

    # patron
    row << "," + escape_double_quote(doc.search(".patron").xpath('strong[@class="number"]').text.gsub('人', ''))

    # rest
    row << "," + escape_double_quote(doc.search(".rest").xpath('strong[@class="number"]').text)

    # username
    #row << "," +  doc.search(".username").text
    # pref
    pref = doc.search(".pref").search("li")
    row << "," + escape_double_quote(pref.first.text) unless pref.size == 0
  ensure
    puts row
  end
#  sleep(1+rand(10))
end

