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
    user = User.find_by(username: username)
    halt 404, { error: "Usuário não encontrado" }.to_json unless user

    GameManager.create_room(room_id) unless GameManager.rooms[room_id]
    GameManager.add_player(room_id, "ws://#{request.host}:#{request.port}/game/#{room_id}?username=#{username}", username)

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
    user = User.find_by(username: username)
    halt 404, { error: "Usuário não encontrado" }.to_json unless user

    unless GameManager.rooms[room_id]
      halt 404, { error: "Sala não encontrada" }.to_json
    end

    GameManager.add_player(room_id, "ws://#{request.host}:#{request.port}/game/#{room_id}?username=#{username}", username)

    {
      message: "#{username} entrou na sala #{room_id}",
      room_id: room_id,
      username: username,
      websocket_url: "ws://#{request.host}:#{request.port}/game/#{room_id}?username=#{username}"
    }.to_json
  end

  get '/cards' do 
    content_type :json
    cards = GameManager.shuffled_deck.map do |card|
      { uuid: card.uuid, name: card.class.name, value: card.value }
    end
    cards.to_json
  end

  post '/:room_id/start' do
    content_type :json
    room_id = params[:room_id]

    halt 404, { error: "Sala não encontrada" }.to_json unless GameManager.rooms[room_id]

    GameManager.start_game(room_id)

    { message: "Jogo iniciado na sala #{room_id}" }.to_json
  end

  # Comprar uma carta do deck
  post '/:room_id/draw/:username' do
    content_type :json

    room_id = params[:room_id]
    username = params[:username]

    room = GameManager.rooms[room_id]
    halt 404, { error: "Sala não encontrada" }.to_json unless room

    player = room[:players].find { |p| p[:username] == username }
    halt 404, { error: "Jogador não encontrado na sala" }.to_json unless player

    card = GameManager.draw_card(room_id, username)
    halt 400, { error: "Deck vazio" }.to_json unless card

    {
      message: "#{username} comprou uma carta",
      carta_comprada: { uuid: card.uuid, name: card.class.name, value: card.value },
      hand: player[:hand].map { |c| { uuid: c.uuid, name: c.class.name, value: c.value } }
    }.to_json
  end

  # Jogar uma carta da mão
  # Agora recebe o UUID da carta
  post '/:room_id/play/:username' do
    content_type :json
    room_id = params[:room_id]
    username = params[:username]
    played_uuid = params[:card_uuid] # ⚡ trocado de index → uuid
    puts played_uuid
    room = GameManager.rooms[room_id]
    halt 404, { error: "Sala não encontrada" }.to_json unless room
    
    player = room[:players].find { |p| p[:username] == username }
    halt 404, { error: "Jogador não encontrado na sala" }.to_json unless player
    
    played_card = GameManager.play_card(room_id, username, played_uuid)
    halt 400, { error: "Carta inválida" }.to_json unless played_card
  
    # Determina se a carta precisa de alvo
    needs_target = [Guarda, Padre, Barao, Principe, Rei].include?(played_card.class)
  
    if needs_target && !params[:target_username]
      halt 400, { error: "Alvo não fornecido" }.to_json 
    end
    
    target = nil
    if needs_target && params[:target_username]
      target = room[:players].find { |p| p[:username] == params[:target_username] }
      halt 404, { error: "Alvo não encontrado" }.to_json unless target
    end
  
    # Executa o efeito
    effect_result = if target
      played_card.play(player, room, target: target, options: { guess: params[:guess] })
    else
      played_card.play(player, room)
    end

    {
      message: "#{username} jogou a carta #{played_card.class.name}",
      efeito: effect_result,
      remaining_hand: player[:hand].map { |c| { uuid: c.uuid, name: c.class.name, value: c.value } }
    }.to_json
  end

  # Retorna as cartas da mão de um jogador
  get '/:username/:room_id/cards' do
    content_type :json
    username = params[:username]
    user = User.find_by(username: username)
    halt 404, { error: "Usuário não encontrado" }.to_json unless user
    
    room_id = params[:room_id]
    room = GameManager.rooms[room_id]
    halt 404, { error: "Sala não encontrada" }.to_json unless room

    player = room[:players].find { |p| p[:username] == username }
    halt 404, { error: "Jogador não encontrado na sala" }.to_json unless player

    {
      hand: player[:hand].map { |c| { uuid: c.uuid, name: c.class.name, value: c.value } }
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
