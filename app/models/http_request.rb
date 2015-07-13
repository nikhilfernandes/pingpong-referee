class HttpRequest

  def self.post(host, port, path, params, auth_token)
    headers = { 'Content-Type' => 'application/json', 'accept' => 'application/json' }
    http = Net::HTTP.new(host, port)
    payload = JSON.generate params
    request = Net::HTTP::Post.new(path, headers)    
    res = http.request(request, payload)
  end
  
end