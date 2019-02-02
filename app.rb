require 'sinatra'
require 'sinatra/activerecord'
require './app/models/text.rb'

set :database_file, "config/database.yml"

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get "/" do
    Text.first.content
  end
end
