class VictoryCondition
  constructor: (@name, @id ,@icon) ->
    @description = "An event occurred"
    @priority = 0

  hasBusinessMetConditions: (business) ->
    return no


class BootstrapEnding extends VictoryCondition
  constructor: ->
    super "Bootstrapped","sal","dollar"
    @description = "Squeezing lemons by hand? Nope. Now, you just roll over them with a Ferrari. I guess that means you made it?"
    @priority = 10

  hasBusinessMetConditions: (business) ->
    conditionsMet = yes
    if business.stats.cash < 100000
      conditionsMet = no
    if business.stats.equity < 100
      conditionsMet = no
    return conditionsMet

class ALittleBetterEnding extends VictoryCondition
  constructor: ->
    super "Still in Business","sal","thumb-up"
    @description = "I can pay myself now!"
    @priority = 1

  hasBusinessMetConditions: (business) ->
    conditionsMet = yes
    if business.stats.cash < 25000
      conditionsMet = no
    if business.stats.equity <= 0
      conditionsMet = no
    return conditionsMet

class StagnantEnding extends VictoryCondition
  constructor: ->
    super "Still Here","sal","dollar"
    @description = "Yesterday, I squeezed lemons, today I am squeezing lemons, and tomorrow I will squeeze lemons. Lemon, lemon, something, lemon."
    @priority = 1

  hasBusinessMetConditions: (business) ->
    conditionsMet = yes
    if business.stats.cash >= 25000
      conditionsMet = no
    if business.stats.equity <= 0
      conditionsMet = no
    return conditionsMet

class AcquiredEnding extends VictoryCondition
  constructor: ->
    super "JuiceBook is Calling","sal","thumb-up"
    @description = "Lemons? Have fun with that. I'm out. See you in Paris."
    @priority = 9

  hasBusinessMetConditions: (business) ->
    conditionsMet = yes
    if business.stats.projectedValue < 5000000
      conditionsMet = no
    if business.stats.fundraising < 50
      conditionsMet = no
    if business.stats.development < 20
      conditionsMet = no
    if business.stats.marketing < 30
      conditionsMet = no
    return conditionsMet

class SoftHostileTakeoverEnding extends VictoryCondition
  constructor: ->
    super "'Voluntary' Resignation","sal","thumb-up"
    @description = "The board pushed you out. But you got paid. Lemons are so passé anyway. Time to disrupt the world of Agave."
    @priority = 7

  hasBusinessMetConditions: (business) ->
    conditionsMet = yes
    if business.stats.equity > 50
      conditionsMet = no
    return conditionsMet

class HostileTakeoverEnding extends VictoryCondition
  constructor: ->
    super "Hostile Takeover","sal","thumb-down"
    @description = "You barely own the business anymore and you weren't doing the business any favours"
    @priority = 8

  hasBusinessMetConditions: (business) ->
    conditionsMet = yes
    if business.stats.cash > 15000
      conditionsMet = no
    if business.stats.equity > 50
      conditionsMet = no
    return conditionsMet

class BankruptEnding extends VictoryCondition
  constructor: ->
    super "Bankrupt","sal","thumb-down"
    @description = "The lemonade stand? Oh, no, I work at Starbucks now."
    @priority = 1

  hasBusinessMetConditions: (business) ->
    conditionsMet = yes
    if business.stats.cash > 0
      conditionsMet = no
    return conditionsMet