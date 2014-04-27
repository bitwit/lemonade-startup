class VictoryCondition
  constructor: (@name, @id ,@icon) ->
    @description = "An event occurred"
    @priority = 0
    @criteria = { #false here means that the criteria is not considered for the VC. If true, the value of the flag from the business is checked for true.
      doesHaveAvailableFunds: false
      doesHaveAvailableEquity: false
      playerHasMajorityEquity: false
      playerHasTotalOwnership: false
      cashOnHandIsPositive: false
      hasPassedHighThreshold_Cash: false
      hasPassedHighThreshold_Research: false
      hasPassedHighThreshold_Development: false
      hasPassedHighThreshold_Design: false
      hasPassedHighThreshold_Marketing: false
      hasPassedHighThreshold_Sales: false
      hasPassedHighThreshold_Fundraising: false
      hasPassedHighThreshold_MarketSize: false
      hasPassedLowThreshold_Cash: false
      isBroke: false
      isUnderLowThreshold_Cash: false
      playerHasSoldOut: false
    }

  hasBusinessMetConditions: (business) ->
    console.log "#{@name} conditions being checked"
    criteriaMet = yes
    for flag, value of @criteria
      if value != false
        console.log "checking #{flag}", value, business.flags[flag], business.flags
        if business.flags[flag] != true
          criteriaMet = no

    if criteriaMet
      console.log "#{@name} condition was met"
    else
      console.log "#{@name} condition was NOT met"

    return criteriaMet


class BootstrapEnding extends VictoryCondition
  constructor: ->
    super "Bootstrapped","sal","dollar"
    @description = "Squeezing lemons by hand? Nope. Now, you just roll over them with a Ferrari. I guess that means you made it?"
    @criteria.doesHaveAvailableFunds = true
    @criteria.playerHasTotalOwnership = true
    @criteria.hasPassedHighThreshold_Cash = true
    @priority = 10

class StagnantEnding extends VictoryCondition
  constructor: ->
    super "Still Here","sal","dollar"
    @description = "Yesterday, I squeezed lemons, today I am squeezing lemons, and tomorrow I will squeeze lemons. Lemon, lemon, something, lemon."
    @criteria.doesHaveAvailableFunds = true
    @criteria.doesHaveAvailableEquity = true
    @criteria.isUnderLowThreshold_Cash = true
    @priority = 1

class AcquiredEnding extends VictoryCondition
  constructor: ->
    super "JuiceBook is Calling","sal","thumb-up"
    @description = "Lemons? Have fun with that. I'm out. See you in Paris. No, not that one - secret Paris."
    @criteria.hasPassedHighThreshold_Fundraising = true
    @criteria.hasPassedHighThreshold_Development = true
    @criteria.hasPassedHighThreshold_Marketing = true
    @criteria.doesHaveAvailableFunds = true
    @priority = 9

class HostileTakeoverEnding extends VictoryCondition
  constructor: ->
    super "You Can't Fire me!","sal","thumb-up"
    @description = "Oh. You can? But ... This was ... Seriously? You're having security escort me out?"
    @criteria.isBroke = true
    @criteria.playerHasSoldOut = true
    @priority = 7

class SoftHostileTakeoverEnding extends VictoryCondition
  constructor: ->
    super "'Voluntary' Resignation","sal","thumb-up"
    @description = "The board pushed your out. But you got paid. Lemons are so passé anyway. Time to disrupt the world of Agave."
    @criteria.playerHasSoldOut = true
    @criteria.isUnderLowThreshold_Cash = true
    @priority = 8

class BankruptEnding extends VictoryCondition
  constructor: ->
      super "Bankrupt","sal","thumb-down"
      @description = "The lemonade stand? Oh, no, I work at Starbucks now."
      @criteria.isBroke = true
      @priority = 1

class ALittleBetterEnding extends VictoryCondition
  constructor: ->
    super "Still in Business","sal","thumbs-down"
    @description = "I can pay myself now!"
    @criteria.doesHaveAvailableFunds = true
    @criteria.doesHaveAvailableEquity = true
    @criteria.hasPassedLowThreshold_Cash = true
    @priority = 1

