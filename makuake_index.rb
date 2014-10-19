# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
# CSV
# require 'csv'

# スクレイピング先のURL
base_url = 'https://www.makuake.com'
base_url_index = '/discover/index/'
base_url_after = 'all/open/list/'

# escape double quotaion for CSV
def escape_double_quote (s)
  if ( /"/ =~ s )
    return '"' + s.gsub('"','""') + '"'
  else
    return '"' + s + '"'
  end
end


# get index number
last = 1
url = base_url + base_url_index + "1/" + base_url_after
begin
  doc = Nokogiri::HTML(open(url),nil,"utf-8")
rescue
else
  last = doc.search("a.pageRightLast").first.attribute("href").value.gsub('/discover/index/','').gsub('/all/open/list','').to_i
ensure
end
sleep(1+rand(10))


# write header
header = ["url", "title", "owner", "category", "total", "meter", "patron", "rest"]
puts header.inspect.gsub('[','').gsub(']','')


# main
for num in 1..last do 

  url = base_url + base_url_index + num.to_s + '/' + base_url_after
  row = escape_double_quote url

  begin
    doc = Nokogiri::HTML(open(url),nil,"utf-8")
  rescue
    row << "," + escape_double_quote("page not found")
  else

    doc.search(".projectBox").each do |project|
      # url
      row = escape_double_quote(base_url + project.search("a").first.attribute("href").value)

      # title
      row << "," + escape_double_quote(project.search("h2").text.strip)

      # owner
      row << "," + escape_double_quote(project.css("a.projectThumb").search("span").text.strip)

      # category
      row << "," + escape_double_quote(project.css("a.projectTag").text.strip)

      # total
      row << "," + escape_double_quote(project.css("div.projectMoney").search("dd").text.gsub(',','').gsub('円',''))

      # meter
      row << "," + escape_double_quote(project.css("div.projectGageIn").search("p").text)

      # patron
      row << "," + escape_double_quote(project.css("div.projectSupporter").search("dd").text)

      # rest
      row << "," + escape_double_quote(project.css("div.projectTime").search("dd").text)

      puts row
    end
  ensure
  end

  sleep(1+rand(10))
end

