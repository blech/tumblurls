# $ ruby tumblurls.rb
#
require 'rubygems'
require 'sinatra'
require 'liquid'
require 'net/http'

#enable :sessions
use Rack::Session::Pool, :expire_after => 2592000

set :public_folder, File.dirname(__FILE__) + '/static'

# global configuration (oops)
url_fields = 6

# home page
get '/' do
    liquid :index, :locals => { :url_fields => url_fields }
end

# post page
post '/post' do
    # TODO write ALL the codes
    liquid :post, :locals => { :data => params }
    
end