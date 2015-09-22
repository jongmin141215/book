require 'sinatra/base'
require_relative '.././data_mapper_setup'

class BookmarkManager < Sinatra::Base
  set :views, proc {File.join(root,'..','/views')}

  get '/links' do
    Link.create(:title => "Makers Academy", :url => 'http://www.makersacademy.com')
    @links = Link.all
    erb :'links/index'
  end

  # post '/links' do
  #   Link.new(:title => "Makers Academy", :url => 'http://www.makersacademy.com')
  #   redirect '/links'
  # end


end
