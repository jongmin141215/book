require_relative './data_mapper_setup'
require 'sinatra/partial'
require_relative 'helpers'

  class BookmarkManager < Sinatra::Base
    include AppHelpers
    register Sinatra::Flash
    register Sinatra::Partial
    use Rack::MethodOverride
    set :partial_template_engine, :erb
    set :views, proc {File.join(root,'..','/app/views')}
    enable :sessions
    set :session_secret, 'super secret'

    get '/' do
      redirect to('/links')
    end

    get '/links' do
      @links = Link.all
      erb :'links/index'
    end

    get '/links/new' do
      erb :'links/new'
    end

    post '/links' do
      link = Link.new(url:   params[:url],
                      title: params[:title],
                      tag:   params[:tags])
      params[:tags] == "" ? params[:tags] = "no tags" : params[:tags]
      tags_array = params[:tags].split(" ")
      tags_array.each do |word|
        tag = Tag.create(name: word)
        link.tags << tag
        link.save
      end
      redirect to('/links')
    end

    get '/tags/:name' do
      tag = Tag.first(name: params[:name])
      @links = tag ? tag.links : []
      erb :'links/index'
    end

    get '/users/new' do
      @user = User.new
      erb :'users/new'
    end

    post '/users' do
      @user = User.new(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
      if @user.save
        session[:user_id] = @user.id
        redirect to('/')
      else
        flash.now[:errors] = @user.errors
        erb :'users/new'
      end
    end

    get '/sessions/new' do
      erb :'sessions/new'
    end

    post '/sessions' do
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        redirect to('/links')
      else
        flash.now[:errors] = ['The email or password is incorrect']#flash it to layout
        erb :'sessions/new'
      end
    end

    delete '/sessions' do
      session[:user_id] = nil
      redirect('/goodbye')
    end

    get '/goodbye' do
      erb :'sessions/goodbye'
    end


  run! if app_file == BookmarkManager
end
