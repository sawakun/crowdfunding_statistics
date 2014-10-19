# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
base_url = 'http://shootingstar.jp/'

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
  doc = Nokogiri::HTML(open(base_url))
rescue
else
  links = doc.search("a")
  links.each do |link|
    ref = link.attribute("href").value
    next unless /http:\/\/shootingstar.jp\/projects\/\d+/ =~ ref
    p_id = ref.gsub("http://shootingstar.jp/projects/","").to_i
    latest = p_id if p_id > latest
  end
ensure
end

# write header
header = ["url", "title", "owner", "category", "total", "target", "patron", "rest", "close_date", "meter", "status"]
puts header.inspect.gsub('[','').gsub(']','')


# main
#projects = [14, 18, 38, 64, 74, 75, 106, 111, 134, 136, 151, 153, 164, 173, 178, 179, 188, 222, 223, 225, 236, 246, 252, 283, 289, 292, 293, 297, 311, 314, 315, 318, 320, 323, 324, 327, 328, 339, 342, 357, 360, 379, 385, 404, 406, 409, 412, 420, 424, 426, 427, 434, 439, 441, 442, 447, 453, 462, 468, 475, 476, 487, 492, 493, 494, 497, 516, 534, 536, 548, 561, 565, 572, 582, 583, 623, 656, 675, 676, 678, 681, 683, 689, 702, 713, 716, 726, 733, 740, 743, 747, 748, 754, 765, 766, 767, 775, 779, 786, 792, 812, 813, 834, 837, 838, 854, 855, 868, 876, 880, 895, 924, 936, 954, 956, 970, 975, 985, 990, 1028, 1036, 1048, 1058, 1093, 1094, 1098, 1129, 1142, 1145, 1161, 1177, 1183, 1189, 1194, 1201, 1209, 1212, 1229, 1257, 1261, 1263, 1330, 1335, 1352, 1361, 1366]
for num in 1..latest do 
#projects.each do |num|

  url = base_url + "projects/" + num.to_s
  row = escape_double_quote(url)

  begin
    doc = Nokogiri::HTML(open(url))
  rescue
    row << "," + escape_double_quote("page not found")
  else

    # title
    row << "," + escape_double_quote(doc.css("#project_title_area").text)

    # owner
    row << "," + escape_double_quote(doc.css("div.owner_name > a").text.strip)

    # category
    row << "," + escape_double_quote(doc.css("#pj_info > ul").search("span.category").text.strip)

    # total
    row << "," + escape_double_quote(doc.css("#pj_info").css("p.amount").first.text.strip.gsub("￥",""))

    # target
    row << "," + escape_double_quote(doc.css("dl.target").search("dd").text.strip.gsub("￥",""))

    # backer
    row << "," + escape_double_quote(doc.css("dl.supporter").search("dd").search("span").text.strip)

    # rest
    row << "," + escape_double_quote(doc.css("dl.times").css("dd > div.t_right > span").text.strip)

    # close_date
    row << "," + escape_double_quote(doc.css("p.funding_goal_txt").text.scan(/\d{4}\/\d{2}\/\d{2}、\d{1,2}時/).first)

    # meter
    meter = doc.css("div.chart").text.strip.to_i
    row << "," + escape_double_quote(meter.to_s + "%")

    # status (CLOSE=SUCCESSして終了、UNSUCCESS=SUCCESSせずに終了、LIVE=募集中かつまだSUCCESSしていない、SUCCESS=募集中かつSUCCESS済み)
    status_text = doc.css("div.project_data").search("a.support").text
    status = ""
    if /支援する/ =~ status_text then
      if meter >= 100
        status = "SUCCESS"
      else
        status = "LIVE"
      end
    elsif /支援期間終了/ =~ status_text then
      if meter >= 100
        status = "CLOSE"
      else
        status = "UNSUCCESS"
      end
    else
      status = "OTHER"
    end
    row << "," + escape_double_quote(status)
  ensure
    puts row
  end
  #  sleep(1+rand(10))
end

