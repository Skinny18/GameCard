# guarda.rb
require_relative 'base_card'

class Guarda < Card
  VALUE = 1
  QTD = 5

  def play(player, game, target: nil, options: {})
    return unless target # carta precisa de alvo
    return if target[:protected]

    guess = options[:guess]
    if target[:hand].first.class.name == guess
      game.eliminate_player(target)
    end
  end
end

# padre.rb
class Padre < Card
  VALUE = 2
  QTD = 2

  def play(player, game, target:, options: {})
    return if target[:protected]
    puts "#{player[:username]} olha a mão de #{target[:username]}: #{target[:hand].first.class.name}"
  end
end

# barao.rb
class Barao < Card
  VALUE = 3
  QTD = 2

  def play(player, game, target:, options: {})
    return if target[:protected]
    p1_val = player[:hand].first.value
    p2_val = target[:hand].first.value
    if p1_val > p2_val
      game.eliminate_player(target)
    elsif p1_val < p2_val
      game.eliminate_player(player)
    end
  end
end

# aia.rb
class Aia < Card
  VALUE = 4
  QTD = 2

  def play(player, game, target: nil, options: {})
    player[:protected] = true
  end
end

# principe.rb
class Principe < Card
  VALUE = 5
  QTD = 2

  def play(player, game, target:, options: {})
    target[:hand].clear
    game.draw_card_for_player(target)
  end
end

# rei.rb
class Rei < Card
  VALUE = 6
  QTD = 2

  def play(player, game, target:, options: {})
    return if target[:protected]
    player[:hand], target[:hand] = target[:hand], player[:hand]
  end
end

# condessa.rb
class Condessa < Card
  VALUE = 7
  QTD = 2

  def play(player, game, target: nil, options: {})
    puts "#{player[:username]} jogou a Condessa"
  end
end

# princesa.rb
class Princesa < Card
  VALUE = 8
  QTD = 2

  def play(player, game, target: nil, options: {})
    game.eliminate_player(player)
  end
end

# chanceler.rb
class Chanceler < Card
  VALUE = 6
  QTD = 2

  def play(player, game, target: nil, options: {})
    2.times { game.draw_card_for_player(player) }
    # player escolhe qual carta ficar (pode implementar lógica aqui)
  end
end

# espia.rb
class Espia < Card
  VALUE = 0
  QTD = 2

  def play(player, game, target: nil, options: {})
    player[:played_spia] = true
  end
end
