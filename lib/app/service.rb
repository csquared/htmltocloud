module Service 
  class Base < Sinatra::Base
    before do
      @auth = Rack::Auth::Basic::Request.new(request.env)
      @user_id, @api_key = @auth.credentials
      @cloud_store = CloudStore.new(@user_id.to_i)
      @user = User.get(@user_id)
      @data = params[:url] || params[:html]
      halt "Must include html via url or html parameter" unless @data
    end 

    use Rack::Auth::Basic do |id, api_key|
      ((u = User.get(id)) && (u.api_key == api_key))
    end
  end

  class IMG < Base
    get '/img' do
      #list all as json  
    end

    get '/img/:hash' do
      #sendfile  
    end

    post '/img' do
      Resque.enqueue(Workers::CreateIMG, @user.id, @data)
      @user.public_url(@data, 'jpg').to_s
    end

    delete '/img/:hash' do
      Resque.enqueue(Workers::DeleteIMG, @user.id, params[:hash]) and "ok"
    end
  end

  class PDF < Base
    get '/pdf' do
      #list all as json
    end

    get '/pdf/:hash' do
      #sendfile  
    end

    post '/pdf' do
      Resque.enqueue(Workers::CreatePDF, @user.id, @data)
      @user.public_url(@data, 'pdf').to_s
    end

    delete '/pdf/:hash' do
      Resque.enqueue(Workers::DeletePDF, @user.id, params[:hash]) and "ok"
    end
  end
end
