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
      req.body = params
    end        
  end

  def self.put(host, port, path, params, auth_token)    
    conn = Faraday.new(:url => "#{host}:#{port}") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end      
    headers = [['Cache-Control', 'no-store'],['Content-Type', 'application/x-www-form-urlencoded'], ["X_AUTHENTICATION_TOKEN", auth_token]]
    
    
    response = conn.put do |req|
      req.url path
      req.headers = Faraday::Utils::Headers.new(headers)
      req.body = params
    end        
  end

end