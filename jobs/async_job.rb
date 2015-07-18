class AsyncJob
  
  @queue = :async_background_worker


  def self.perform(params)

    @params = params
    puts "AsyncJob #{@params}"
    HttpRequest.post(@params["host"], @params["port"], @params["path"], @params["payload"], @params["auth_token"])   if @params["method"] == "post"
    HttpRequest.put(@params["host"], @params["port"], @params["path"], @params["payload"], @params["auth_token"])   if @params["method"] == "put"    
  end
end  