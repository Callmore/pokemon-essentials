# NOTE: If you're inventing new move effects, use function code 176 and onwards.
#       Actually, you might as well use high numbers like 500+ (up to FFFF),
#       just to make sure later additions to Essentials don't clash with your
#       new effects.

# projectOriginality: start at function code 1000

#===============================================================================
# No additional effect.
# (An Attack)
#===============================================================================
class PokeBattle_Move_1000 < PokeBattle_Move
end

#===============================================================================
# Boosts Fire moves for 6(?) turns.
# (Smolder Install)
#===============================================================================
class PokeBattle_Move_1001 < PokeBattle_Move
    def pbFailsAgainstTarget?(user)
    if user.effects[PBEffects::SmolderInstall]
        @battle.pbDisplay(_INTL("But it failed!"))
        return true
    end
    return false
    end
    #todo: damage calc changes
    def pbEffectAgainstTarget(user)
        user.effects[PBEffects::SmolderInstall] = 6
        @battle.pbDisplay(_INTL("{1}'s Fire-type moves are boosted!", user.pbThis))
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
class PokeBattle_Move_1005 < PokeBattle_BurnMove
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
            @battle.pbDisplay(_INTL("But it failed!"))
            return true
        elsif user.totalhp == user.hp
            @battle.pbDisplay(_INTL("{1}'s HP is already full!", user.pbThis))
            return true
        end
        return false
    end

    def pbCalcDamage(user,target,numTargets=1)
        if target.stages[:SPECIAL_ATTACK] > 0
            pbShowAnimation(@id,user,target,1)   # Stat stage-draining animation
            @battle.pbDisplay(_INTL("{1} turned {2}'s Special Attack boosts into health!", user.pbThis, target.pbThis))
            #1-6
            #I don't know if this will actually work
            hpGain = ((user.totalhp/2/6)*target.stages[:SPECIAL_ATTACK]).round
            target.stages[:SPECIAL_ATTACK] -= 1
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