# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
urls = ['http://greenfunding.jp/lab/projects/896','https://cf.sportie.jp/sportie/projects/892','http://greenfunding.jp/lab/projects/886','http://greenfunding.jp/lab/projects/887','http://greenfunding.jp/miraibooks/projects/889','http://greenfunding.jp/projectroom/projects/873','http://greenfunding.jp/lab/projects/884','http://greenfunding.jp/allez-japan/projects/883','http://greenfunding.jp/sake/projects/876','http://greenfunding.jp/lab/projects/877','http://greenfunding.jp/lab/projects/868','http://greenfunding.jp/miraibooks/projects/870','http://greenfunding.jp/lab/projects/856','http://greenfunding.jp/miraibooks/projects/850','http://greenfunding.jp/lab/projects/853','http://greenfunding.jp/miraibooks/projects/852','http://greenfunding.jp/compass/projects/849','http://greenfunding.jp/fiat_alfaromeo/projects/839','http://greenfunding.jp/allez-japan/projects/832','http://greenfunding.jp/lab/projects/774','http://greenfunding.jp/fanzing/projects/863','http://greenfunding.jp/compass/projects/859','http://greenfunding.jp/fiat_alfaromeo/projects/847','http://greenfunding.jp/allez-japan/projects/855','http://greenfunding.jp/lab/projects/265',
        'http://greenfunding.jp/lab/projects/235','https://cf.sportie.jp/sportie/projects/835','http://greenfunding.jp/lab/projects/243','http://greenfunding.jp/lab/projects/836','http://greenfunding.jp/compass/projects/829','http://greenfunding.jp/allez-japan/projects/834','http://greenfunding.jp/changemaker/projects/831','http://greenfunding.jp/lab/projects/828','http://greenfunding.jp/lab/projects/814','http://greenfunding.jp/projectroom/projects/827','http://greenfunding.jp/lab/projects/821','http://greenfunding.jp/lab/projects/808','http://greenfunding.jp/allez-japan/projects/820','http://greenfunding.jp/fiat_alfaromeo/projects/817','http://greenfunding.jp/miraifes/projects/815','http://greenfunding.jp/miraibooks/projects/807','https://cf.sportie.jp/sportie/projects/806','http://greenfunding.jp/allez-japan/projects/809','http://greenfunding.jp/lab/projects/803','http://greenfunding.jp/allez-japan/projects/805','http://greenfunding.jp/allez-japan/projects/801','http://greenfunding.jp/fiat_alfaromeo/projects/791','http://greenfunding.jp/lab/projects/794','http://greenfunding.jp/gamelife/projects/788',
        'http://greenfunding.jp/allez-japan/projects/789','http://greenfunding.jp/allez-japan/projects/785','https://cf.sportie.jp/sportie/projects/755','http://greenfunding.jp/miraifes/projects/764','https://cf.sportie.jp/sportie/projects/773','http://greenfunding.jp/allez-japan/projects/767','http://greenfunding.jp/nylonjapan/projects/765','http://greenfunding.jp/miraibooks/projects/758','https://meetaup.jp/meetaup/projects/760','http://greenfunding.jp/miraibooks/projects/736','http://greenfunding.jp/allez-japan/projects/759','http://greenfunding.jp/miraibooks/projects/731','https://meetaup.jp/meetaup/projects/754','https://cf.sportie.jp/sportie/projects/740','https://meetaup.jp/meetaup/projects/753','http://greenfunding.jp/fiat_alfaromeo/projects/729','http://greenfunding.jp/allez-japan/projects/752','http://greenfunding.jp/allez-japan/projects/751','http://greenfunding.jp/fiat_alfaromeo/projects/746','http://greenfunding.jp/allez-japan/projects/748','http://greenfunding.jp/allez-japan/projects/747','http://greenfunding.jp/miraibooks/projects/742','http://greenfunding.jp/allez-japan/projects/744',
        'http://greenfunding.jp/lab/projects/739','https://meetaup.jp/meetaup/projects/741','http://greenfunding.jp/allez-japan/projects/738','http://greenfunding.jp/allez-japan/projects/735','http://greenfunding.jp/miraibooks/projects/719','http://greenfunding.jp/lab/projects/732','http://greenfunding.jp/lab/projects/716','http://greenfunding.jp/lab/projects/727','http://greenfunding.jp/lab/projects/725','https://cf.sportie.jp/sportie/projects/724','https://cf.sportie.jp/sportie/projects/723','http://greenfunding.jp/lab/projects/704','https://cf.sportie.jp/sportie/projects/710','http://greenfunding.jp/miraibooks/projects/702','http://greenfunding.jp/fiat_alfaromeo/projects/701','http://greenfunding.jp/fiat_alfaromeo/projects/699','http://greenfunding.jp/allez-japan/projects/712','http://greenfunding.jp/allez-japan/projects/711','https://cf.sportie.jp/sportie/projects/703','http://greenfunding.jp/miraifes/projects/697','http://greenfunding.jp/miraibooks/projects/698','http://greenfunding.jp/projectroom/projects/673','http://greenfunding.jp/lab/projects/667','http://greenfunding.jp/changemaker/projects/590',
        'http://greenfunding.jp/tdc/projects/687','http://greenfunding.jp/allez-japan/projects/691','http://greenfunding.jp/allez-japan/projects/690','http://greenfunding.jp/changemaker/projects/688','http://greenfunding.jp/miraifes/projects/686','http://greenfunding.jp/allez-japan/projects/683','http://greenfunding.jp/lab/projects/674','http://greenfunding.jp/miraifes/projects/680','http://greenfunding.jp/miraifes/projects/655','http://greenfunding.jp/allez-japan/projects/668','http://greenfunding.jp/lab/projects/666','https://cf.sportie.jp/sportie/projects/661','http://greenfunding.jp/miraibooks/projects/663','http://greenfunding.jp/miraibooks/projects/650','http://greenfunding.jp/lab/projects/659','http://greenfunding.jp/changemaker/projects/664','http://greenfunding.jp/tokyo-calendar/projects/652','https://cf.sportie.jp/sportie/projects/277','https://cf.sportie.jp/sportie/projects/646','http://greenfunding.jp/allez-japan/projects/645','http://greenfunding.jp/projectroom/projects/622','http://greenfunding.jp/lab/projects/617','http://greenfunding.jp/tdc/projects/632','http://greenfunding.jp/tdc/projects/631',
        'http://greenfunding.jp/allez-japan/projects/624','http://greenfunding.jp/tokyo-calendar/projects/619','http://greenfunding.jp/projectroom/projects/616','https://cf.sportie.jp/sportie/projects/618','http://greenfunding.jp/lab/projects/614','http://greenfunding.jp/lab/projects/589','http://greenfunding.jp/allez-japan/projects/613','https://cf.sportie.jp/sportie/projects/605','http://greenfunding.jp/lab/projects/609','http://greenfunding.jp/timeouttokyo/projects/606','http://greenfunding.jp/lab/projects/608','http://greenfunding.jp/lab/projects/596','http://greenfunding.jp/timeouttokyo/projects/558','http://greenfunding.jp/lab/projects/576','http://greenfunding.jp/lab/projects/564','https://cf.sportie.jp/sportie/projects/583','http://greenfunding.jp/allez-japan/projects/601','http://greenfunding.jp/allez-japan/projects/600','http://greenfunding.jp/allez-japan/projects/599','http://greenfunding.jp/allez-japan/projects/598','http://greenfunding.jp/lab/projects/565','http://greenfunding.jp/allez-japan/projects/586','http://greenfunding.jp/lab/projects/373',
        'http://greenfunding.jp/changemaker/projects/588','http://greenfunding.jp/changemaker/projects/585','http://greenfunding.jp/changemaker/projects/582','https://meetaup.jp/meetaup/projects/577','http://greenfunding.jp/tokyo-calendar/projects/428','http://greenfunding.jp/tokyo-calendar/projects/424','https://meetaup.jp/meetaup/projects/574','https://meetaup.jp/meetaup/projects/573','http://greenfunding.jp/lab/projects/560','http://greenfunding.jp/projectroom/projects/572','http://greenfunding.jp/allez-japan/projects/571','https://meetaup.jp/meetaup/projects/563','http://greenfunding.jp/allez-japan/projects/552','http://greenfunding.jp/lab/projects/550','http://greenfunding.jp/sustena/projects/406','http://greenfunding.jp/lab/projects/402','https://cf.sportie.jp/sportie/projects/427','http://greenfunding.jp/lab/projects/542','http://greenfunding.jp/allez-japan/projects/538','http://greenfunding.jp/lab/projects/463','https://cf.sportie.jp/sportie/projects/400','http://greenfunding.jp/tokyo-calendar/projects/393','http://greenfunding.jp/lab/projects/389','http://greenfunding.jp/sustena/projects/387','http://greenfunding.jp/timeouttokyo/projects/378','http://greenfunding.jp/lab/projects/375','http://greenfunding.jp/allez-japan/projects/401',
        'http://greenfunding.jp/sustena/projects/398','http://greenfunding.jp/allez-japan/projects/394','http://greenfunding.jp/tokyo-calendar/projects/369','https://cf.sportie.jp/sportie/projects/380','http://greenfunding.jp/nylonjapan/projects/321','http://greenfunding.jp/sustena/projects/374','http://greenfunding.jp/allez-japan/projects/372','http://greenfunding.jp/timeouttokyo/projects/367','http://greenfunding.jp/timeouttokyo/projects/366','http://greenfunding.jp/sustena/projects/352','http://greenfunding.jp/allez-japan/projects/353','https://cf.sportie.jp/sportie/projects/347','http://greenfunding.jp/tokyo-calendar/projects/362','http://greenfunding.jp/allez-japan/projects/338','http://greenfunding.jp/tokyo-calendar/projects/361','http://greenfunding.jp/tokyo-calendar/projects/332','https://cf.sportie.jp/sportie/projects/325','http://greenfunding.jp/lab/projects/320','http://greenfunding.jp/lab/projects/287','https://cf.sportie.jp/sportie/projects/282','http://greenfunding.jp/lab/projects/267','http://greenfunding.jp/lab/projects/240','http://greenfunding.jp/sustena/projects/351','http://greenfunding.jp/allez-japan/projects/339','http://greenfunding.jp/nylonjapan/projects/333','http://greenfunding.jp/allez-japan/projects/329','http://greenfunding.jp/allez-japan/projects/328','http://greenfunding.jp/allez-japan/projects/327','http://greenfunding.jp/lab/projects/323','http://greenfunding.jp/allez-japan/projects/315','http://greenfunding.jp/allez-japan/projects/314','http://greenfunding.jp/allez-japan/projects/313','http://greenfunding.jp/nylonjapan/projects/311','http://greenfunding.jp/timeouttokyo/projects/309','https://cf.sportie.jp/sportie/projects/268','http://greenfunding.jp/lab/projects/248','http://greenfunding.jp/lab/projects/241']

# escape double quotaion for CSV
def escape_double_quote (s)
  return '""' if s.nil?
  if ( /"/ =~ s )
    return '"' + s.gsub('"','""') + '"'
  else
    return '"' + s + '"'
  end
end


# write header
header = ["url", "success_date", "target"] 
puts header.inspect.gsub('[','').gsub(']','')

urls.each do |url|
  row = escape_double_quote(url)

  begin
    doc = Nokogiri::HTML(open(url.gsub("http://","https://")),nil,"utf-8")
  rescue
    row << "," + escape_double_quote("page not found")
  else
    #success_date
    row << "," + escape_double_quote(doc.css("div.l-sidebar").search("p").text.scan(/\d{4}年\d{1,2}月\d{1,2}日/).first)

    #target
    row << "," + escape_double_quote(doc.css("div.l-sidebar").search('div.amount__scope').text.gsub('目標金額　¥ ','').gsub('円',''))

  ensure
    puts row
#    sleep(1+rand(10))
  end
end
