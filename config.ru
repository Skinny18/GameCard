require './app/app.rb'
require './app/controllers/users_controller'
require './app/controllers/rooms_controller'

run Rack::URLMap.new(
  "/" => App.new,                  # rota principal
  "/users" => UsersController.new,  # API de usuários
  "/rooms" => RoomsController.new  # API de usuários

)