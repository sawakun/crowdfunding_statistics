# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


# スクレイピング先のURL
base_url = 'https://motion-gallery.net'


# escape double quotaion for CSV
def escape_double_quote (s)
  if ( /"/ =~ s )
    return '"' + s.gsub('"','""') + '"'
  else
    return '"' + s + '"'
  end
end


# get latest index
url = base_url + "/projects"
latest = 2
begin
  doc = Nokogiri::HTML(open(url),nil,"utf-8")
rescue
else
  links = doc.css("div.pagination").search("li")
  latest = links[links.length-2].search("a").text.to_i
ensure
end


# write header
header = ["url", "title", "owner", "category", "status", "patron", "total", "rest"]
puts header.inspect.gsub('[','').gsub(']','')


# main
for num in 1..latest do 

  url = base_url + "/projects?page="  + num.to_s
  row = escape_double_quote(url)

  begin
    doc = Nokogiri::HTML(open(url),nil,"utf-8")
  rescue
    row << "," + escape_double_quote(" page not found")
  else

    doc.search(".pjtItem").each do |project|
      # url
      row = escape_double_quote(base_url + project.search(".pjtTitle").search("a").attribute("href").value)

      # title
      row << "," + escape_double_quote(project.search(".pjtTitle").search("a" ).text.strip)
      
      # owner
      row << "," + escape_double_quote(project.css("li.presenter").search("a").text.strip)

      # category
      row << "," + escape_double_quote(project.css("li.categoryTag").search("a").text.strip)

      # status
      status_text = project.css("div.progress").search("p").text.strip
      if status_text.empty?
        status_text = "LIVE"
      elsif status_text == "FUNDED!"
        status_text = "SUCCESS"
      elsif status_text == "NOT FUNDED!"
        status_text = "UNSUCCESS" 
      else
        status_text = "OTHER"
      end
      row << "," + escape_double_quote(status_text)

      status = project.css("ul.pjtStatus").search("li")
      if status.size > 0 then
        # patron
        row << "," + escape_double_quote(status[0].search("span").text)

        # total
        row << "," + escape_double_quote(status[1].search("span").text.gsub(',',''))

        # rest
        row << "," + escape_double_quote(status[2].text.gsub("残り",""))
      else
      end
      puts row
    end
  ensure
  end
end

