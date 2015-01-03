require 'sinatra'
require 'net/http'
require 'rubygems'

set :public_folder, File.join(File.dirname(__FILE__),'build')

get '/ping' do
  'pong'
end

get '/' do
  redirect '/index.html'
end

get '/psn' do
  Net::HTTP.get(URI("https://support.us.playstation.com/app/answers/detail/a_id/237/"))
end

get '/wow' do
  Net::HTTP.get(URI("https://us.api.battle.net/wow/realm/status?locale=en_US&apikey=ukm5wf6j68hwj35k57gr7tesgz8pe9k4"))
end

get '/steam' do
  Net::HTTP.get(URI("https://steamdb.info/api/SteamRailgun/"))
end

get '/xbox' do
  Net::HTTP.get(URI("http://support.xbox.com/en-US/xbox-live-status"))
end

get '/euf/assets/images/:a' do
  ''
end

get '/Content/Images/LiveStatus/:a' do
  ''
end

get '/shell/images/shell/:a' do
  ''
end
