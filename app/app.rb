require_relative './data_mapper_setup'
require 'sinatra/partial'
require_relative 'helpers'
require './app/controllers/link_controller'
require './app/controllers/base_controller'

include TheApp::Models
module TheApp
  class BookmarkManager < Sinatra::Base
    include AppHelpers
    register Sinatra::Flash
    register Sinatra::Partial

    get '/' do
      redirect to('/links')
    end

    use Routes::LinkController

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
end
