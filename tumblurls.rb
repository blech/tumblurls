# $ ruby tumblurls.rb
#
require 'rubygems'
require 'sinatra'
require 'liquid'
require 'httparty'
require 'oauth'

set :public_folder, File.dirname(__FILE__) + '/static'
enable :sessions
# use Rack::Session::Pool, :key => 'rack.session'

# global configuration (oops)
url_fields = 6

# oauth for tumblr
key = "3luShD2ApVSMWKRXTQdmvGac7IIrVUAkVk0BKjQJwkowCYgSNh"
secret = "yrZ8Wu7422TeHUp7iinWvI8QwQM4Yu7ENqYfiQKKwG12vk5l5z"
site = 'http://www.tumblr.com'
consumer = OAuth::Consumer.new(key, secret,
                               { :site => site,
                                 :request_token_path => '/oauth/request_token',
                                 :authorize_path => '/oauth/authorize',
                                 :access_token_path => '/oauth/access_token',
                                 :http_method => :post })

@callback_url = 'http://127.0.0.1:9393/'

# home page
get '/' do
    liquid :index, :locals => { :url_fields => url_fields }
end

# post page
post '/post' do
    # TODO write ALL the codes
    liquid :post, :locals => { :data => params }
    
end

# oauth page
get '/oauth' do
    request_token = consumer.get_request_token(:oauth_callback => @callback_url)
    session[:request_token] = request_token
    puts session[:request_token]
    redirect request_token.authorize_url
end

get '/callback' do
    request_token = session[:request_token]
    puts request_token
    if request_token then
        puts params[:oauth_token]
        puts params[:oauth_verifier]
        access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
        puts access_token
        session[:access_token] = access_token
    end
    
    # redirect "/info"
    # liquid :callback
end

get '/info' do
    access_token = session[:access_token]
    puts access_token
    if access_token then
        user_info = access_token.get("http://api.tumblr.com/v2/user/info")
        puts user_info
    else
        halt 500
    end
end