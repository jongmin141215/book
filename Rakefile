require 'data_mapper'
require './app/data_mapper_setup'

task :auto_upgrade do
  DataMapper.auto_upgrade!
  puts "Auto-upgrade completed!"
end

task :auto_migrate do
  DataMapper.auto_migrate!
  puts "Auto-migrate completed!"
end
