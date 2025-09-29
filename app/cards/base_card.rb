# base_card.rb
class Card
  attr_reader :name, :value, :qtd

  def initialize
    @name = self.class.name
    @value = self.class::VALUE
    @qtd = self.class::QTD 
  end

  # Cada carta implementa seu próprio efeito
  def play(player, target = nil, game = nil, options = {})
    raise NotImplementedError, "Cada carta deve implementar play"
  end
end


