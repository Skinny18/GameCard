class GameManager
  @@rooms = {} # { room_id => { players: [], deck: [], ... } }

  def self.create_room(room_id)
    @@rooms[room_id] = { players: [], deck: shuffled_deck }
  end

  def self.add_player(room_id, ws, username)
    return unless @@rooms[room_id]
    @@rooms[room_id][:players] << { ws: ws, username: username }
  end

  def self.broadcast(room_id, message)
    return unless @@rooms[room_id]
    @@rooms[room_id][:players].each do |p|
      p[:ws].send(message.to_json)
    end
  end

  def self.shuffled_deck
    cards = [
      Guarda.new, Padre.new, Barao.new, Aia.new,
      Principe.new, Rei.new, Condessa.new, Princesa.new,
      Chanceler.new, Espia.new
    ]
    cards * 2 # ajusta quantidade para 16 cartas
    cards.shuffle
  end

  def self.rooms
    @@rooms
  end
end
