#===============================================================================
#
#===============================================================================
class Player < Trainer
  attr_accessor :has_snag_machine
  attr_accessor :seen_purify_chamber

  alias __shadowPkmn__initialize initialize
  def initialize(name, trainer_type)
    __shadowPkmn__initialize(name, trainer_type)
    @has_snag_machine    = false
    @seen_purify_chamber = false
  end
end

