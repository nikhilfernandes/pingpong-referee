rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'


redis_config = YAML.load_file(rails_root + '/config/redis.yml')
url          = redis_config[rails_env]['redis']
Resque.redis    = url

Dir[File.dirname(__FILE__) + '/../jobs/*.rb'].each do |file|
  require File.basename(file, File.extname(file))
end