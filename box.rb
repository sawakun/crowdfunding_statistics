# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
url = 'http://camp-fire.jp/category/art'

charset = nil
html = open(url) do |f|
    charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

boxes = doc.xpath('//div[@class = "box-main"]')

boxes.each do |box|
  h4 =  box.xpath('h4')
  p h4.text
  p h4.xpath('.//a').attribute("href").value
  
  
  meter = box.xpath('div[@class = "meter"]')
  p meter.xpath('.//span').text
  overview = box.xpath('div[@class= "overview"]')
  p overview.xpath('div[@class = "total"]').text
  p overview.xpath('div[@class = "rest"]').text
  p overview.xpath('div[@class = "per"]').text
  p ""
end
