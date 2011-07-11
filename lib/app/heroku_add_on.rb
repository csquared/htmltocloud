module Service
  class HerokuAddOn < Sinatra::Base
    MANIFEST = Crack::JSON.parse(File.read(File.join(APP_ROOT,'addon-manifest.json')))
    NAV_HEADER = HTTParty.get('http://nav.heroku.com/v1/providers/header').body rescue nil
    use Rack::Session::Cookie, secret: SESSION_SECRET

    helpers do
      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && 
        @auth.credentials == [MANIFEST['id'], MANIFEST['api']['password']]
      end
    end

    get "/heroku/resources/:id" do
      pre_token = params[:id] + ':' + MANIFEST['api']['sso_salt'] + ':' + params[:timestamp]
      token = Digest::SHA1.hexdigest(pre_token).to_s
      halt 403 if token != params[:token]
      halt 403 if params[:timestamp].to_i < (Time.now - 2*60).to_i

      account = User.get(params[:id])
      halt 404 unless account

      session[:user] = account.id
      session[:heroku_sso] = true
      response.set_cookie('heroku-nav-data', value: params['nav-data'], path: '/')
      redirect "/account"
    end

    post '/heroku/resources' do
      protected!
      u = User.create(:identifier => "heroku_#{Time.now.to_i}")
      {id: u.id, config: {"HTML2CLOUD_URL" => u.auth_url}}.to_json
    end

    delete '/heroku/resources/:id' do
      protected!
      User.get(params[:id]).destroy
      "ok"
    end
  end
end
