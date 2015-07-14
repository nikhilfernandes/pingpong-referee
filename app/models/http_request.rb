require "addressable/uri"
class HttpRequest

  def self.post(host, port, path, params, auth_token)    
    conn = Faraday.new(:url => "#{host}:#{port}") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end      
    headers = [['Cache-Control', 'no-store'],['Content-Type', 'application/x-www-form-urlencoded'], ["X_AUTHENTICATION_TOKEN", auth_token]]
    
    
    response = conn.post do |req|
      req.url path
      req.headers = Faraday::Utils::Headers.new(headers)
      req.body = ::Addressable::URI.form_encode(params)
    end    
    # headers = { 'Content-Type' => 'application/json', 'accept' => 'application/json', "X_AUTHENTICATION_TOKEN"=> auth_token }
    # http = Net::HTTP.new(host, port)
    # payload = JSON.generate params
    # request = Net::HTTP::Post.new(path, headers)    
    # res = http.request(request, payload)
  end

end