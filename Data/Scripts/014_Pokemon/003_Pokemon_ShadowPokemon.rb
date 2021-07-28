#===============================================================================
# Pokémon class.
#===============================================================================
class Pokemon
  attr_accessor :shadow
  attr_writer   :hyper_mode
  attr_accessor :saved_ev
  attr_accessor :shadow_moves
  HEART_GAUGE_SIZE = 3840

  alias :__shadow_hpeq :hp=
  def hp=(value)
    __shadow_hpeq(value)
    @hyper_mode = false if @hp <= 0
  end

  def shadowPokemon?
    return @shadow
  end
  alias isShadow? shadowPokemon?

  def hyper_mode
    return (@hp == 0) ? false : @hyper_mode
  end

  def makeShadow
    @shadow       = true
    @hyper_mode   = false
    @saved_ev     = {}
    GameData::Stat.each_main { |s| @saved_ev[s.id] = 0 }
    @shadow_moves = []
    # Retrieve Shadow moveset for this Pokémon
    shadow_moveset = pbLoadShadowMovesets[species_data.id]
    shadow_moveset = pbLoadShadowMovesets[@species] if !shadow_moveset || shadow_moveset.length == 0
    # Record this Pokémon's Shadow moves
    if shadow_moveset && shadow_moveset.length > 0
      for i in 0...[shadow_moveset.length, MAX_MOVES].min
        @shadow_moves[i] = shadow_moveset[i]
      end
    elsif GameData::Move.exists?(:SHADOWRUSH)
      # No Shadow moveset defined; just use Shadow Rush
      @shadow_moves[0] = :SHADOWRUSH
    else
      # If moves are not defined then don't give them any and return.
      @shadow_moves = nil
    end
    # Record this Pokémon's original moves
    @moves.each_with_index { |m, i| @shadow_moves[MAX_MOVES + i] = m.id } if @shadow_moves
    # Update moves
    update_shadow_moves
  end

  def update_shadow_moves(relearn_all_moves = false)
    return if !@shadow_moves
    # Is a Shadow Pokémon; ensure it knows the appropriate moves depending on its heart stage
    # Start with all Shadow moves
    new_moves = []
    @shadow_moves.each_with_index { |m, i| new_moves.push(m) if m && i < MAX_MOVES }
    num_shadow_moves = new_moves.length
    # Add some original moves (skipping ones in the same slot as a Shadow Move)
    num_original_moves = 3
    if num_original_moves > 0
      relearned_count = 0
      @shadow_moves.each_with_index do |m, i|
        next if !m || i < MAX_MOVES + num_shadow_moves
        new_moves.push(m)
        relearned_count += 1
        break if relearned_count >= num_original_moves
      end
      @shadow_moves = nil
    end
    # Relearn Shadow moves plus some original moves (may not change anything)
    replace_moves(new_moves)
  end

  def replace_moves(new_moves)
    new_moves.each do |move|
      next if !move || !GameData::Move.exists?(move) || hasMove?(move)
      if numMoves < Pokemon::MAX_MOVES   # Has an empty slot; just learn move
        learn_move(move)
        next
      end
      @moves.each do |m|
        next if new_moves.include?(m.id)
        m.id = GameData::Move.get(move).id
        break
      end
    end
  end

  def add_evs(added_evs)
    total = 0
    @ev.each_value { |e| total += e }
    GameData::Stat.each_main do |s|
      addition = added_evs[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - @ev[s.id])
      addition = addition.clamp(0, Pokemon::EV_LIMIT - total)
      next if addition == 0
      @ev[s.id] += addition
      total += addition
    end
  end

  alias :__shadow_clone :clone
  def clone
    ret = __shadow_clone
    if @saved_ev
      GameData::Stat.each_main { |s| ret.saved_ev[s.id] = @saved_ev[s.id] }
    end
    ret.shadow_moves = @shadow_moves.clone if @shadow_moves
    return ret
  end
end
