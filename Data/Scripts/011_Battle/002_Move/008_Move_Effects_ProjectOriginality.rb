# NOTE: If you're inventing new move effects, use function code 176 and onwards.
#       Actually, you might as well use high numbers like 500+ (up to FFFF),
#       just to make sure later additions to Essentials don't clash with your
#       new effects.

# projectOriginality: start at function code 1000

#===============================================================================
# No additional effect.
# (An Attack)
# a noise
#===============================================================================
class PokeBattle_Move_1000 < PokeBattle_Move
end

#===============================================================================
# Boosts Fire moves for 6(?) turns.
# (Smolder Install)
#===============================================================================
class PokeBattle_Move_1001 < PokeBattle_Move
    def pbMoveFailed?(user, target)
        if user.effects[PBEffects::SmolderInstall] > 0
            @battle.pbDisplay(_INTL("But it failed!"))
            return true
        end
        return false
    end

    def pbEffectGeneral(user)
        user.effects[PBEffects::SmolderInstall] = 6
        @battle.pbDisplay(_INTL("{1}'s Fire-type moves are boosted for 6 turns!", user.pbThis))
    end
end

#===============================================================================
# No additional effect.
# (i don't wanna write this name ffs)
#===============================================================================
class PokeBattle_Move_1002 < PokeBattle_Move
end

#===============================================================================
# Drastically raises Speed
# (Justice Pose S)
#===============================================================================
class PokeBattle_Move_1003 < PokeBattle_StatUpMove
    def initialize(battle,move)
        super
        @statUp = [:SPEED,2]
    end
end

#===============================================================================
# Drastically raises Attack
# (Justice Pose P)
#===============================================================================
class PokeBattle_Move_1004 < PokeBattle_StatUpMove
    def initialize(battle,move)
        super
        @statUp = [:ATTACK,2]
    end
end

#===============================================================================
# Burns the target
# (Frenetic Flambe)
#===============================================================================
class PokeBattle_Move_1005 < PokeBattle_Move
    def pbEffectWhenDealingDamage(user,target)
        return if target.damageState.substitute
        target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
end

#===============================================================================
# May flinch the target
# (Aero Blade)
#===============================================================================
class PokeBattle_Move_1006 < PokeBattle_Move
    def pbAdditionalEffect(user,target)
        return if target.damageState.substitute
        target.pbFlinch(user)
    end
end

#===============================================================================
# May burn the target
# (Freeze Burn)
#===============================================================================
class PokeBattle_Move_1007 < PokeBattle_Move
    def pbAdditionalEffect(user,target)
        return if target.damageState.substitute
        target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
end

#===============================================================================
# User restores health based on the target's Special Attack boosts. Lowers target's Special Attack.
# (Soul Drain)
#===============================================================================
class PokeBattle_Move_1008 < PokeBattle_Move
    def healingMove?; return true; end

    def pbFailsAgainstTarget?(user, target)
        if target.stages[:SPECIAL_ATTACK] <= 0
            @battle.pbDisplay(_INTL("But there were no Special Attack boosts to sap!"))
            return true
        elsif user.totalhp == user.hp
            @battle.pbDisplay(_INTL("{1}'s HP is already full!", user.pbThis))
            return true
        end
        return false
    end

    def pbEffectAgainstTarget(user,target,numTargets=1)
        if target.stages[:SPECIAL_ATTACK] > 0
            pbShowAnimation(@id,user,target,1)   # Stat stage-draining animation
            @battle.pbDisplay(_INTL("{1} turned {2}'s Special Attack boosts into health!", user.pbThis, target.pbThis))
            #1-6
            #I don't know if this will actually work
            hpGain = ((user.totalhp/2/6)*target.stages[:SPECIAL_ATTACK]).round
            target.stages[:SPECIAL_ATTACK] -= 1
            user.pbRecoverHP(hpGain)
        end
        super
    end
end

#===============================================================================
# May burn the target
# (Fire Spray)
#===============================================================================
class PokeBattle_Move_1009 < PokeBattle_Move
    def pbAdditionalEffect(user,target)
        return if target.damageState.substitute
        target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
end

#===============================================================================
# May burn the target
# (Bullet Spray)
#===============================================================================
class PokeBattle_Move_100A < PokeBattle_Move
    def pbAdditionalEffect(user,target)
        return if target.damageState.substitute
        target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
end

#===============================================================================
# Causes confusion
# (PSI Megalomania)
#===============================================================================
class PokeBattle_Move_100B < PokeBattle_ConfuseMove
    def pbEffectAgainstTarget(user,target)
        return if target.damageState.substitute
        target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
end

#===============================================================================
# No effect.
# (Galant Leaf Storm)
#===============================================================================
class PokeBattle_Move_100C < PokeBattle_Move
    def pbMoveFailed?(user,targets)
        @battle.pbDisplay(_INTL("But it failed!"))
        return true
    end
end

#===============================================================================
# Power increases every turn, for 4 more turns. User is locked into this move for 5 turns.
# Attack ends early when missing or taking damage.
# (Grave Digger)
#===============================================================================
class PokeBattle_Move_100D < PokeBattle_Move
    def pbBaseDamage(baseDmg,user,target)
        shift = (5 - user.effects[PBEffects::GraveDigger])   # 0-4, where 0 is most powerful
        shift = 0 if user.effects[PBEffects::GraveDigger] == 0   # For first turn
        baseDmg *= 2**shift
        return baseDmg
    end

    def pbEffectAfterAllHits(user,target)
        if !target.damageState.unaffected && user.effects[PBEffects::GraveDigger] == 0
            user.effects[PBEffects::GraveDigger] = 5
            user.currentMove = @id
        end
        user.effects[PBEffects::GraveDigger] -= 1 if user.effects[PBEffects::GraveDigger] > 0
    end

    def pbMissMessage(user,target)
        @battle.pbDisplay(_INTL("{1} evaded the attack!",target.pbThis))
        user.effects[PBEffects::GraveDigger] = 0
        user.currentMove = nil
        @battle.pbDisplay(_INTL("{1}'s {2} ended!",user.pbThis, @name))
        return true
    end
end

#===============================================================================
# Increased critical hit chance. Hits 2-5 times.
# (Soul Volley)
# Increase crit chance is applied thru move flags, not here
#===============================================================================
class PokeBattle_Move_100E < PokeBattle_Move_0C0
end

#===============================================================================
# May inflict paralysis. Hits 2-5 times.
# (Plasma Beam)
#===============================================================================
class PokeBattle_Move_100F < PokeBattle_Move_0C0
    # same story as PokeBattle_Move_0A4
    def pbEffectAfterAllHits(user,target)
        return if target.damageState.substitute
        target.pbParalyze(user) if target.pbCanParalyze?(user,false,self)
    end
end

#===============================================================================
# May inflict paralysis.
# (Plasma Sword)
#===============================================================================
class PokeBattle_Move_1010 < PokeBattle_Move
    def pbAdditionalEffect(user,target)
        return if target.damageState.substitute
        target.pbParalyze(user) if target.pbCanParalyze?(user,false,self)
    end
end


#===============================================================================
# Harshly lowers user's special attack. Attacks after 2 turns.
# (Concentrated Plasma Beam)
#===============================================================================
class PokeBattle_Move_1011 < PokeBattle_TwoTurnMove
    def pbAdditionalEffect(user,target)
        if target.pbCanLowerStatStage?(:SPECIAL_ATTACK,user,self)
            target.pbLowerStatStage(:SPECIAL_ATTACK,1,user)
        end
    end
end

#===============================================================================
# Making contact with the user after this move is used inflicts paralysis and deals 15 damage.
# (Plasma Cover)
#===============================================================================
class PokeBattle_Move_1012 < PokeBattle_Move
    def pbFailsAgainstTarget?(user, target)
        if user.effects[PBEffects::PlasmaCover]
            @battle.pbDisplay(_INTL("But it failed!"))
            return true
        end
        return false
    end
    #todo: damage calc changes
    def pbEffectAgainstTarget(user, target)
        user.effects[PBEffects::PlasmaCover] = true
        @battle.pbDisplay(_INTL("{1} gained a Plasma Cover!", user.pbThis))
    end
end

#===============================================================================
# Always does critical hits. Move uses lowest priority bracket.
# (One-Hundred Iron Clad Fists)
#===============================================================================
class PokeBattle_Move_1013 < PokeBattle_Move
    def pbCritialOverride(user,target)
        return 1
    end
end

#===============================================================================
# Move calls a different move depending on user's held Elemental Stone (Physical)
# (Elemental Surge)
# Borrow code from Nature Power for this
# Fire: Flame Charge
# Grass: Razor Leaf
# Water: Aqua Jet
# Electric: Nuzzle
#===============================================================================
class PokeBattle_Move_1014 < PokeBattle_Move
    def callsAnotherMove?; return true; end

    def pbOnStartUse(user,targets)
        @npMove = :ELEMSURGE
        case user.item_id
        when :ELEMSTONEFIRE
            @npMove = :FLAMECHARGE if GameData::Move.exists?(:FLAMECHARGE)
        when :ELEMSTONEGRASS
            @npMove = :RAZORLEAF if GameData::Move.exists?(:RAZORLEAF)
        when :ELEMSTONEWATER
            @npMove = :AQUAJET if GameData::Move.exists?(:AQUAJET)
        when :ELEMSTONEELEC
            @npMove = :NUZZLE if GameData::Move.exists?(:NUZZLE)
        end
    end
    
    def pbEffectAgainstTarget(user,target)
        if @npMove != :ELEMSURGE
            @battle.pbDisplay(_INTL("{1} turned into {2}!", @name, GameData::Move.get(@npMove).name))
            user.pbUseMoveSimple(@npMove, target.index)
        end
    end
end

#===============================================================================
# Move calls a different move depending on user's held Elemental Stone (Special)
# (Elemental Blast)
# Borrow code from Nature Power for this
# Fire: Flame Burst
# Grass: Grass Knot
# Water: Water Pulse
# Electric: Discharge
#===============================================================================
class PokeBattle_Move_1015 < PokeBattle_Move
    def callsAnotherMove?; return true; end

    def pbOnStartUse(user,targets)
        @npMove = :ELEMBLAST
        case user.item_id
        when :ELEMSTONEFIRE
            @npMove = :FLAMEBURST if GameData::Move.exists?(:FLAMEBURST)
        when :ELEMSTONEGRASS
            @npMove = :GRASSKNOT if GameData::Move.exists?(:GRASSKNOT)
        when :ELEMSTONEWATER
            @npMove = :WATERPULSE if GameData::Move.exists?(:WATERPULSE)
        when :ELEMSTONEELEC
            @npMove = :DISCHARGE if GameData::Move.exists?(:DISCHARGE)
        end
    end
    
    def pbEffectAgainstTarget(user,target)
        if @npMove != :ELEMSURGE
            @battle.pbDisplay(_INTL("{1} turned into {2}!", @name, GameData::Move.get(@npMove).name))
            user.pbUseMoveSimple(@npMove, target.index)
        end
    end
end

#===============================================================================
# Move calls a different move depending on user's held Elemental Stone (Status)
# (Elemental Veil)
# Borrow code from Nature Power for this
# Fire: Will-o-wisp
# Grass: Leech Seed
# Water: Aqua Ring
# Electric: Thunder Wave
# Move fails if user doesn't have an Elemental Stone held
#===============================================================================
class PokeBattle_Move_1016 < PokeBattle_Move
    items = [:ELEMSTONEFIRE, :ELEMSTONEGRASS, :ELEMSTONEWATER, :ELEMSTONEELEC]
    def callsAnotherMove?; return true; end

    def pbOnStartUse(user,targets)
        @npMove = :ELEMVEIL
        case user.item_id
        when :ELEMSTONEFIRE
            @npMove = :WILLOWISP if GameData::Move.exists?(:WILLOWISP)
        when :ELEMSTONEGRASS
            @npMove = :LEECHSEED if GameData::Move.exists?(:LEECHSEED)
        when :ELEMSTONEWATER
            @npMove = :AQUARING if GameData::Move.exists?(:AQUARING)
        when :ELEMSTONEELEC
            @npMove = :THUNDERWAVE if GameData::Move.exists?(:THUNDERWAVE)
        end
    end
    
    def pbEffectAgainstTarget(user,target)
        if @npMove != :ELEMVEIL
            @battle.pbDisplay(_INTL("{1} turned into {2}!", @name, GameData::Move.get(@npMove).name))
            user.pbUseMoveSimple(@npMove, target.index)
        end
    end

    def pbMoveFailed?(user,targets)
        if !items.include?(user.item_id)
            @battle.pbDisplay(_INTL("But it failed!"))
            return true
        end
        return false
    end
end

#===============================================================================
# Damage is split across all targets (cap damage at 100 per target)
# (All-Out Heat)
#===============================================================================
class PokeBattle_Move_1017 < PokeBattle_Move
    numTargets = 0
    def pbOnStartUse(user,targets)
        numTargets = targets.length()
    end

    def pbBaseDamage(baseDmg,user,target)
        return [baseDmg / numTargets, 100].min
    end
end

#===============================================================================
# Binds the target
# (All-Out Growth)
#===============================================================================
class PokeBattle_Move_1018 < PokeBattle_Move
    def pbEffectAgainstTarget(user,target)
        user.pbUseMoveSimple(:BIND, target.index)
    end
end

#===============================================================================
# No additional effect (Hits adjacent targets)
# (All-Out Tide)
#===============================================================================
class PokeBattle_Move_1019 < PokeBattle_Move
end

#===============================================================================
# Flinches all opponents
# (All-Out Shock)
#===============================================================================
class PokeBattle_Move_101A < PokeBattle_Move
    def flinchingMove?; return true; end

    def pbEffectAgainstTarget(user,target)
        target.pbFlinch(user)
    end
end

#===============================================================================
# No effect. (make a mega evolution or primal form type thing instead)
# (Henshin)
#===============================================================================

#===============================================================================
# Has a chance of confusing the target.
# (Tail Tornado)
#===============================================================================
class PokeBattle_Move_101B < PokeBattle_ConfuseMove
    def pbMoveFailed?(user,targets)
        failed = true
        targets.each do |b|
          next if !b.pbCanConfuse?(user,false,self)
          failed = false
          break
        end
        if failed
          @battle.pbDisplay(_INTL("But it failed!"))
          return true
        end
        return false
    end
end

#===============================================================================
# Hits 2-5 times.
# (Magic Chakram)
#===============================================================================
class PokeBattle_Move_101C < PokeBattle_Move_0C0
end

#===============================================================================
# Raises Def and Sp.Def after two turns. Buff is increased if user is hit during the waiting turn.
# (Scuffed Preperation)
#===============================================================================
class PokeBattle_Move_101D < PokeBattle_TwoTurnMove
    def pbChargingTurnMessage(user,targets)
        user.effects[PBEffects::ScuffedPrep] = 1
        @battle.pbDisplay(_INTL("{1} started preparing!",user.pbThis))
    end

    def pbEffectGeneral(user)
        return if !@damagingTurn
        showAnim = true
        [:DEFENSE,:SPECIAL_DEFENSE].each do |s|
            next if !user.pbCanRaiseStatStage?(s,user,self)
            if user.pbRaiseStatStage(s,user.effects[PBEffects::ScuffedPrep],user,showAnim)
                showAnim = false
            end
        end
        user.effects[PBEffects::ScuffedPrep] = 0
    end
end

#===============================================================================
# Harshly lowers target's Sp.Atk. User cannot move for one turn after using the move
# Technical: Two turn move that applies effects on turn one.
# (Soul Shatter Smash)
#===============================================================================
class PokeBattle_Move_101E < PokeBattle_TwoTurnMove
    def pbDamagingMove?   # inverse of the original function
        return false if @damagingTurn
        return super
    end

    def pbChargingTurnEffect(user,target)
        target.pbLowerStatStage(:SPECIAL_ATTACK,2,user,showAnim)
    end
end

#===============================================================================
# Increased crit chance.
# (Aero Ass)
#===============================================================================
class PokeBattle_Move_101F < PokeBattle_Move
end

#===============================================================================
# Does not check accuracy.
# (Blobby Bop)
#===============================================================================
class PokeBattle_Move_1020 < PokeBattle_Move_0A5
end

#===============================================================================
# Usually goes first.
# (Speed Weed)
#===============================================================================
class PokeBattle_Move_1021 < PokeBattle_Move
end

#===============================================================================
# Burns the target.
# (Scorcher)
#===============================================================================
class PokeBattle_Move_1022 < PokeBattle_Move
    def pbEffectWhenDealingDamage(user,target)
        return if target.damageState.substitute
        target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
end


#===============================================================================
# Removes the target's stat boosts
# (Lamp's Curse)
#===============================================================================
class PokeBattle_Move_1023 < PokeBattle_Move
    def pbCalcDamage(user,target,numTargets=1)
        if target.hasRaisedStatStages?
          pbShowAnimation(@id,user,target,1)   # Stat stage-draining animation
          @battle.pbDisplay(_INTL("{1} removed the target's stat boosts!",user.pbThis))
          showAnim = true
          GameData::Stat.each_battle do |s|
            target.statsLowered = true
            target.stages[s.id] = 0
          end
        end
        super
    end
end

#===============================================================================
# Lays spikes on the target's side if there aren't any already.
# (Bushido-Earth)
#===============================================================================
class PokeBattle_Move_1024 < PokeBattle_Move
    def pbEffectGeneral(user)
        if user.pbOpposingSide.effects[PBEffects::Spikes] <= 0
            user.pbOpposingSide.effects[PBEffects::Spikes] += 1
            @battle.pbDisplay(_INTL("Spikes were scattered all around {1}'s feet!",
            user.pbOpposingTeam(true)))
        end
    end
end

#===============================================================================
# Sets up a Tailwind for 4 turns.
# (Bushido-Wind)
#===============================================================================
class PokeBattle_Move_1025 < PokeBattle_Move
    def pbEffectGeneral(user)
        user.pbOwnSide.effects[PBEffects::Tailwind] = 4
        @battle.pbDisplay(_INTL("The Tailwind blew from behind {1}!",user.pbTeam(true)))
    end
end

#===============================================================================
# Burns the target.
# (Bushido-Fire)
#===============================================================================
class PokeBattle_Move_1026 < PokeBattle_Move
    def pbEffectWhenDealingDamage(user,target)
        return if target.damageState.substitute
        target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
end

#===============================================================================
# Always crits.
# (Bushido-Soul)
#===============================================================================
class PokeBattle_Move_1027 < PokeBattle_Move
    def pbCritialOverride(user,target)
        return 1
    end
end

#===============================================================================
# Dual typed Ink and Fighting
# If field is Inked, and user moves first(?), raise user Evasion
# (Squid Roll)
# TODO
#===============================================================================
class PokeBattle_Move_1028 < PokeBattle_Move
    def initialize(battle, move)
        super
        @type2 = :FIGHTING
    end
end

#===============================================================================
# Creates an Inked terrain.
# (Splatfest)
# TODO
#===============================================================================
class PokeBattle_Move_1029 < PokeBattle_Move
end

#===============================================================================
# Recovers 8-10% max HP, 
# restores 1-3 PP to all Ink type special attacks
# fails if terrain isn't Inked
# (Ink-overy)
# TODO
#===============================================================================
class PokeBattle_Move_102A < PokeBattle_Move
end

#===============================================================================
# missing creates the Inked terrain
# (E-lite Charge)
# TODO
#===============================================================================
class PokeBattle_Move_102B < PokeBattle_Move
end

#===============================================================================
# Hits 4-8 times
# each attack uses 1 extra PP
# (Ink Shot)
# TODO
#===============================================================================
class PokeBattle_Move_102C < PokeBattle_Move_0C0
end

#===============================================================================
# Guaranteed to do critical hits against Normal Types.
# (Revolt Screech)
#===============================================================================
class PokeBattle_Move_102D < PokeBattle_Move
    def pbCalcTypeModSingle(moveType,defType,user,target)
        return Effectiveness::SUPER_EFFECTIVE_ONE if defType == :NORMAL
        return super
    end
end

#===============================================================================
# Lower target's priority bracket next turn, rarely inflicts confusion
# (Play Dumb)
#===============================================================================
class PokeBattle_Move_102E < PokeBattle_ConfuseMove
    def pbEffectAgainstTarget(user,target)
        target.effects[PBEffects::PlayDumb] = 2
    end
    
    def pbAdditionalEffect(user,target)
        target.pbConfuse if target.pbCanConfuse?(user,false,self)
    end
end

#===============================================================================
# Harsly lowers user's Special Atttack
# May poison the target
# The PBS definition of this move should have everyone as targets
# (Reverbating Shock)
#===============================================================================
class PokeBattle_Move_102F < PokeBattle_PoisonMove
end

#===============================================================================
# User swaps Evasion and Special Attack boosts
# (Woomy Wares)
#===============================================================================
class PokeBattle_Move_1030 < PokeBattle_Move
    def pbMoveFailed?(user)
        if (user.stages[:EVASION] == 0 && user.stages[:SPECIAL_ATTACK] == 0)
            @battle.pbDisplay(_INTL("But it failed!"))
            return true 
        end
        return false
    end

    def pbEffectGeneral(user)
        user.stages[:EVASION], user.stages[:SPECIAL_ATTACK] = user.stages[:SPECIAL_ATTACK], user.stages[:EVASION]
        @battle.pbDisplay(_INTL("{1} swapped their Evasion and Special Attack boosts!",user.pbThis))
    end
end