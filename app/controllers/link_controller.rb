module TheApp
  module Routes
    class LinkController < Base
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
    end
  end
end
