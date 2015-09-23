require_relative './data_mapper_setup'

class BookmarkManager < Sinatra::Base
  set :views, proc {File.join(root,'..','/app/views')}
  enable :sessions
  register Sinatra::Flash
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
    @user = User.create(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:notice] = "Password and confirmation password do not match"
      erb :'users/new'
    end

  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

run! if app_file == BookmarkManager
end
