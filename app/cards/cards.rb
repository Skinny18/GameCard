# guarda.rb
class Guarda < Card
  VALUE = 1
  QTD = 5
  def play(player, target, game, options = {})
    guess = options[:guess]
    return if target.protected
    if target.hand.first.name == guess
      game.eliminate_player(target)
    end
  end
end

# padre.rb
class Padre < Card
  VALUE = 2

  def play(player, target, game, options = {})
    return if target.protected
    puts "#{player.name} olha a mão de #{target.name}: #{target.hand.first.name}"
  end
end

# barão.rb
class Barao < Card
  VALUE = 3

  def play(player, target, game, options = {})
    return if target.protected
    p1_val = player.hand.first.value
    p2_val = target.hand.first.value
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

  def play(player, game, options = {})
    player.protected = true
  end
end

# principe.rb
class Principe < Card
  VALUE = 5

  def play(player, target, game, options = {})
    target.discard_hand(game)
    target.draw_card(game)
  end
end

# rei.rb
class Rei < Card
  VALUE = 6

  def play(player, target, game, options = {})
    return if target.protected
    player.swap_hand(target)
  end
end

# condessa.rb
class Condessa < Card
  VALUE = 7

  def play(player, game, options = {})
    # Efeito principal: obrigatória se tiver Rei ou Príncipe
    puts "#{player.name} jogou a Condessa"
  end
end

# princesa.rb
class Princesa < Card
  VALUE = 8

  def play(player, game, options = {})
    game.eliminate_player(player)
  end
end

# chanceler.rb
class Chanceler < Card
  VALUE = 6 # ou outro valor adequado

  def play(player, game, options = {})
    player.draw_multiple_cards(game, 2)
    player.choose_card_to_keep(game)
  end
end

# espiã.rb
class Espia < Card
  VALUE = 0

  def play(player, game, options = {})
    # Nenhum efeito imediato
    player.played_spia = true
  end
end
