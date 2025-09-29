# app.rb
require 'sinatra/base'
require 'sinatra/namespace'
require 'json'
require 'active_record'
require './config/database.rb'
require 'faye/websocket'
require './app/game_manager'
# carregar controllers
Dir[File.join(__dir__, "controllers", "*.rb")].sort.each { |file| require file }
# carregar models
Dir[File.join(__dir__, "models", "*.rb")].sort.each { |file| require file }

class App < Sinatra::Base
  register Sinatra::Namespace

  before do
    content_type :json
  end

  get "/" do
    { message: "API do CardGame está no ar 🚀" }.to_json
  end

end
