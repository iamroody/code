require 'net/http'
require 'json'

class LuosimaoMessageService
  class << self
    attr_reader :config

    def config= configuration
      @config = configuration
    end

    def post(mobile, content)
      puts "Sending SMS to #{mobile}: #{content}"
      uri = URI config[:host]

      request = Net::HTTP::Post.new uri
      request.basic_auth @config[:username], @config[:password]
      request.set_form_data mobile: mobile, message: content

      response = Net::HTTP.start uri.hostname, uri.port, use_ssl: true do |http|
        http.request request
      end

      response_json = JSON.parse response.body

      unless response_json['error'].zero?
        msg = response_json['msg']
        msg += "，敏感词为#{response_json['hit']}" if response_json['error'] == -31
        puts "Sending SMS failed: #{msg}"
      end
    end
  end
end

LuosimaoMessageService.config = {
    host: 'https://sms-api.luosimao.com/v1/send.json',
    username: 'api',
    password: 'your password'
}

LuosimaoMessageService.post "phone", "sms content【Signature】"  
