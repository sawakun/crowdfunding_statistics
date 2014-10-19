# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


# スクレイピング先のURL
base_urls = ['https://readyfor.jp/projects/successful', 'https://readyfor.jp/projects']


# escape double quotaion for CSV
def escape_double_quote (s)
  if ( /"/ =~ s )
    return '"' + s.gsub('"','""') + '"'
  else
    return '"' + s + '"'
  end
end


# write header
header = ["url", "title", "status", "meter", "total", "close_date"]
puts header.inspect.gsub('[','').gsub(']','')

base_urls.each do |base_url|

  # get index number
  url = base_url 
  last = 2
  begin
    doc = Nokogiri::HTML(open(url),nil,"utf-8")
  rescue
  else
    last = doc.search("nav.pagination").search("span.page").last.search("a").text.to_i
  ensure
  end


  for num in 1..last do 

    url = base_url + "?page=" + num.to_s
    row = escape_double_quote(url)

    begin
      doc = Nokogiri::HTML(open(url))
    rescue
      row << "," + escape_double_quote("page not found")
    else

      doc.search(".project-card").each do |card|
        # url
        row = escape_double_quote("https://readyfor.jp" + card.search("h2").search("a" ).attribute("href").value)

        # title
        row << "," +  escape_double_quote(card.search("h2").search("a" ).text.strip)

        # meter
        stats = card.search(".project-stats").search("li")
        meter = stats[0].search("strong").text.strip.to_i

        # status
        status_text = card.search(".project-finished").text.strip
        if /プロジェクトが成立しました！/ =~ status_text then
          row << "," + escape_double_quote("CLOSE")
        elsif meter >= 100
          row << "," + escape_double_quote("SUCCESS")
        else
          row << "," + escape_double_quote("LIVE")
        end

        # meter
        row << "," + escape_double_quote(meter.to_s + "%")
        # total
        row << "," + escape_double_quote(stats[1].search("strong").text.gsub(',','').gsub('円','').strip)
        # finish_date
        row << "," + escape_double_quote(stats[2].search(".num").text.strip)

        puts row
      end
    ensure
    end
  end
end

