require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

if ENV['RACK_ENV'] == "production"
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
end

require './app/models/link'
require './app/models/tag'

DataMapper.finalize

DataMapper.auto_upgrade!
