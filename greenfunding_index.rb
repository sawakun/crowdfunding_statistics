# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


# スクレイピング先のURL
base_url = 'https://greenfunding.jp/portals/search'


# escape double quotaion for CSV
def escape_double_quote (s)
  if ( /"/ =~ s )
    return '"' + s.gsub('"','""') + '"'
  else
    return '"' + s + '"'
  end
end


# get latest
latest = 2
begin
  doc = Nokogiri::HTML(open(base_url),nil,"utf-8")
rescue
else
  links = doc.search("div.pagenation-search").css("a")
  latest = links[links.length-2].text.to_i
ensure
end


# write header
header = ["url", "title", "curated_page", "category", "owner", "rest", "patron", "meter", "total"]
puts header.inspect.gsub('[','').gsub(']','')

for num in 1..latest do 

  url = base_url + "?page=" + num.to_s
  row = escape_double_quote(url)
  #  p row

  begin
    doc = Nokogiri::HTML(open(url),nil,"utf-8")
  rescue
    row << "," + escape_double_quote("page not found")
  else

    doc.search(".project").each do |project|
      # url
      row = escape_double_quote(project.search("h2").search("a" ).attribute("href").value)
      
      # title
      row << "," + escape_double_quote(project.search(".project-content").search("h2").search("a" ).text.strip)
      
      # curated_page
      row << "," + escape_double_quote(project.search(".project-curated-page").search("a").text)

      # category
      row << "," + escape_double_quote(project.search(".category").search("a").text.strip)

      # owner
      row << "," + escape_double_quote(project.search(".ownername").search("a").text.strip)

      # finish_date
      footer = project.search(".box-footer").search("h3")
      if footer.size > 0 then
        # rest
        row << "," + escape_double_quote(footer[0].text + "日")
        # patron
        row << "," + escape_double_quote(footer[1].text)
        # meter
        row << "," + escape_double_quote(project.css("h2.progress").search("span").text + "%")
        # total
        row << "," + escape_double_quote(project.css("h2.gathered").text.gsub('¥','').gsub(',',''))
      else
      end

      puts row
    end
  ensure
  end
end

