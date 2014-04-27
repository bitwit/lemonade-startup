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
      isBroke: false
      isUnderLowThreshold_Cash: false
    }

  hasBusinessMetConditions: (business) ->
    criteriaMet = yes
    for flag, value of criteria
      if value != false
        if business.flags[flag] != true
          criteriaMet = no
    return criteriaMet


  class BootstrapEnding extends VictoryCondition
    constructor: ->
      super "Bootstrapped","sal","dollar"
      @description: "Squeezing lemons by hand? Nope. Now, you just roll over them with a Ferrari. I guess that means you made it?"
      @criteria.doesHaveAvailableFunds = true
      @criteria.playerHasTotalOwnership = true
      @criteria.hasPassedHighThreshold_Cash = true
      @priority: 10

  class StagnantEnding extends VictoryCondition
    constructor: ->
      super "Still Here","sal","dollar"
      @description: "Yesterday, I squeezed lemons, today I am squeezing lemons, and tomorrow I will squeeze lemons. Lemon, lemon, something, lemon."
      @criteria.doesHaveAvailableFunds = true
      @criteria.doesHaveAvailableEquity = true
      @criteria.isUnderLowThreshold_Cash = true
      @priority: 1

  class AcquiredEnding extends VictoryCondition
    constructor: ->
      super "JuiceBook is Calling","sal","thumbs-up"
      @description: "Lemons? Have fun with that. I'm out. See you in Paris. No, not that one - secret Paris."
      @criteria.hasPassedHighThreshold_Fundraising = true
      @criteria.hasPassedHighThreshold_Development = true
      @criteria.hasPassedHighThreshold_Marketing = true
      @criteria.doesHaveAvailableFunds = true
      @priority: 9
