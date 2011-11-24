require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'
require "sinatra/reloader" if development?

key = #apikey
service = 'http://api.wunderground.com/api/'
api = '/history_'

get '/' do
  haml :index
end

#api = http://api.wunderground.com/api/[key]/history_20111121/q/98103.json
post '/' do
  @zip = params['zipcode']
  @startdate = params['date']
  @res = ''
  open("#{service}#{key}#{api}#{@startdate}/q/#{@zip}.json") do |f|
    j = JSON.parse f.read
    j['history']['observations'].each { |observation| 
      @res += "<tr><td>#{observation["date"]["pretty"]}</td><td>#{observation["tempm"]}</td></tr>"
    }
  end
  
  @title = "#{@zip} on #{@startdate}"
  haml :results
end