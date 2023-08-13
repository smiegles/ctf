require 'sinatra'
require 'net/http'
require 'uri'

set :logging, false
set :show_exceptions, false

auth = 'iohugsdfksjdfhuiwegrwehrgyuwer'
flag = 'ASV{this_is_a_real_flag}'

get '/' do
   'Welcome! <a href="/download?p=info">Info</a>'
end

get '/download' do
   url = URI.parse('http://localhost:4567/redirect?url=' + params[:p]) 

   found = false

   until found
     host, port = url.host, url.port if url.host && url.port
     req = Net::HTTP::Get.new(url)
     req['X-header'] = auth

     res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
     end


     res.header['location'] ? url = URI.parse(res.header['location']) : found = true
   end

   res.body
end

get '/admin' do
   if request.env['HTTP_X_AUTH_KEY'] != auth || request.env['HTTP_X_AUTH_KEY'].nil?
      return 'Invalid X-Auth-key provided'
   end

   if request.env['HTTP_X_FORWARDED_FOR'] != '127.0.0.1'
      return 'You are not allowed to access this page'
   end


   "<h1>Admin area</h1> <br> #{flag}"
end

get '/info' do
   "Information provided somewhere"
end

get '/redirect' do
   redirect params[:url]
end

error 500 do
   "Something went wrong on our end. Please try again later."
 end