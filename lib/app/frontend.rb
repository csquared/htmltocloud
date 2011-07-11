class FrontEnd < Sinatra::Base 
  set :public, File.expand_path('public', APP_ROOT) 
  set :views, File.expand_path('views', APP_ROOT) 

  use Rack::Session::Cookie, secret: SESSION_SECRET
  use Rack::Flash, accessorize: [:notice, :error] 

  def get_user
    @user = User.get(session[:user])
    unless @user 
      flash['error'] = 'Invalid account or not logged in'
      redirect '/' 
    end
    @user
  end

  get '/account' do
    get_user
    haml :account, :layout => :user_layout
  end

  get '/api' do
    get_user
    haml :api_samples, :layout => :user_layout
  end

  get '/sso_on' do
    session[:heroku_sso] = true
    redirect '/account'
  end

  get '/sso_off' do
    session[:heroku_sso] = false
    redirect '/account'
  end

  get '/signout' do
    session.delete(:user)
    redirect '/'
  end

  post '/login' do
    response = Janrain.auth_info(params[:token])  
    if response['stat'] == 'fail'
      flash['error'] = 'Login failure'
      redirect '/'
    else
      begin
        user = User.from_profile(response['profile'])
      rescue => e
        flash['error'] = e.message
        redirect '/'
      end
      session[:user] = user.id
      redirect '/account'
    end
  end

  get '/' do
    haml :index
  end  
end
