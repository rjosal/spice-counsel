require 'json'
class APIClient
  API_SERVER = 'http://localhost:8081'

  def self.search(user_id, biz_id)
    uri = "#{API_SERVER}/prediction?user=#{user_id}&biz=#{biz_id}"
    begin
      resp = JSON.parse(Net::HTTP.get( URI.parse(uri) ))
      if resp and "OK".eql?(resp['status'])
        return resp['prediction']
      else
        return 'N/A'
      end
    rescue Exception => ex
      Rails.logger.error("Error #{ex}")  
    end
  end
end
