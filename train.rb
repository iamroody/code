# encoding: utf-8
require 'net/http'
require 'rubygems'
require 'json'

uri = URI('http://train.qunar.com/qunar/stationtostation.jsp')
params = { :format=>'json', :from => '西安', :to =>  '北京', :type=> 'oneway', :date=> '20120906', :ver=> '1346752074081', :cityname=> '123456', :callback=> 'XQScript_5'}
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
train = res.body if res.is_a?(Net::HTTPSuccess)

train_json = JSON.parse(train.match(/XQScript_5\((.*)\);/)[1])

train_json['ticketInfo'].each do |e,v|
  puts "#{e} 发车时间#{train_json['trainInfo'][e]['deptTime']} 到达时间#{train_json['trainInfo'][e]['arriTime']}"
  v.each do |seat|
    puts "#{seat['type']}-----------#{seat['pr']}"
  end
  puts ""
end