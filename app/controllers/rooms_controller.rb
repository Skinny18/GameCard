# controllers/rooms_controller.rb
require 'sinatra/base'
require 'json'
require_relative '../game_manager'

class RoomsController < Sinatra::Base
  # Endpoint para criar/entrar em uma sala
  post '/:room_id/create' do
    content_type :json

    room_id = params[:room_id]
    username = params[:username] || "Player#{rand(1000)}"

    # Cria a sala se não existir
    GameManager.create_room(room_id) unless GameManager.rooms[room_id]

    # Retorna os dados necessários para o cliente abrir o WebSocket
    {
      message: "Sala pronta para entrar",
      room_id: room_id,
      username: username,
      websocket_url: "ws://#{request.host}:#{request.port}/game/#{room_id}?username=#{username}"
    }.to_json
  end

  post '/room/:room_id/join' do
    content_type :json

    room_id = params[:room_id]
    username = params[:username] || "Player#{rand(1000)}"

    unless GameManager.rooms[room_id]
      halt 404, { error: "Sala não encontrada" }.to_json
    end

    {
      message: "Pronto para entrar na sala",
      room_id: room_id,
      username: username,
      websocket_url: "ws://#{request.host}:#{request.port}/game/#{room_id}?username=#{username}"
    }.to_json

    GameManager.add_player(room_id, "ws://#{request.host}:#{request.port}/game/#{room_id}?username=#{username}", username) # ws será adicionado no WebSocket

    {
      message: "#{username} entrou na sala #{room_id}"
    }.to_json
    
  end

   get '/rooms' do
    rooms = GameManager.rooms.map do |room_id, room_data|
      {
        room_id: room_id,
        players: room_data[:players].map { |p| p[:username] }
      }
    end

    { rooms: rooms }.to_json
  end
end
