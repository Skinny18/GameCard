require 'securerandom'
require_relative 'cards/cards'

class GameManager
  @@rooms = {} # { room_id => { players: [], deck: [], ... } }

  def self.create_room(room_id)
    @@rooms[room_id] = { players: [], deck: shuffled_deck }
  end

  def self.add_player(room_id, ws, username)
    return unless @@rooms[room_id]
    @@rooms[room_id][:players] << { ws: ws, username: username, hand: [], protected: false }
  end

  def self.broadcast(room_id, message)
    return unless @@rooms[room_id]
    @@rooms[room_id][:players].each do |p|
      p[:ws].send(message.to_json)
    end
  end

  def self.start_game(room_id)
    return unless @@rooms[room_id]

    deck = shuffled_deck
    @@rooms[room_id][:players].each do |player|
      player[:hand] << deck.pop
    end

    @@rooms[room_id][:deck] = deck
    @@rooms[room_id][:discard] = []
  end

  def self.draw_card(room_id, username)
    room = @@rooms[room_id]
    return unless room

    player = room[:players].find { |p| p[:username] == username }
    return unless player

    card = room[:deck].pop
    player[:hand] << card
    card
  end

  def self.play_card(room_id, username, played_card_id)
    room = @@rooms[room_id]
    return unless room


    player = room[:players].find { |p| p[:username] == username }
    return unless player
    puts player[:hand].map { |c| { uuid: c.uuid, name: c.class.name, value: c.value } }

    # Agora procuramos a carta pelo UUID, não pelo index
    played_card = player[:hand].find { |c| c.uuid == played_card_id }
    return unless played_card

    player[:hand].delete(played_card)
    room[:discard] << played_card

    played_card
  end

  def self.eliminate_player(room, player)
    return unless room

    room[:players].delete(player)
    room[:discard] ||= []
    room[:discard] << player[:hand].pop if player[:hand].any?
  end


  def self.shuffled_deck
    classes = [Guarda, Padre, Barao, Aia, Principe, Rei, Condessa, Princesa, Chanceler, Espia]
  
    deck = classes.flat_map do |klass|
      Array.new(klass::QTD) do
        card = klass.new
        card.define_singleton_method(:uuid) { @uuid ||= SecureRandom.uuid }
        card
      end
    end
  
    deck.shuffle
  end

  def self.rooms
    @@rooms
  end
end
