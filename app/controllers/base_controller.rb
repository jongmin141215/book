# module TheApp
#   module Routes
#     class Base < Sinatra::Base
#       register Sinatra::Flash
#       use Rack::MethodOverride
#       set :partial_template_engine, :erb
#       set :views, proc {File.join(root,'..','views')}
#       enable :sessions
#       set :session_secret, 'super secret'
#     end
#   end
# end
