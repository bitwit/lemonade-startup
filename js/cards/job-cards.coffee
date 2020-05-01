class Card
  constructor: (@name, @id, @icon)->
    @development = 0
    @design = 0
    @marketing = 0
    @research = 0
    @sales = 0
    @fundraising = 0
    @potentialMarketSize = 0
    @productivity = 0
    @fixedCostPerDay = 0
    @variableCostPerDay = 0
    @averageDemand = 0

  merge: (business) ->
    stats = business.stats
    stats.development += @development
    stats.design += @design
    stats.marketing += @marketing
    stats.research += @research
    stats.sales += @sales
    stats.fundraising += @fundraising
    stats.potentialMarketSize += @potentialMarketSize
    stats.productivity += @productivity
    stats.fixedCostPerDay += @fixedCostPerDay
    stats.variableCostPerDay += @variableCostPerDay
    stats.averageDemand += @averageDemand

class MarketingCard extends Card
  constructor: ->
    super "Marketing", "mkt", "target"
    @marketing = 2
    @potentialMarketSize = 20

class DevelopmentCard extends Card
  constructor: ->
    super "Development", "dev", "wrench"
    @development = 2
    @variableCostPerDay = -0.02

class ResearchCard extends Card
  constructor: ->
    super "Research", "res", "lightbulb"
    @research = 2
    @fixedCostPerDay = -2

class DesignCard extends Card
  constructor: ->
    super "Design", "des", "brush"
    @design = 2
    @averageDemand = 5
    @variableCostPerDay = 0.01

class SalesCard extends Card
  constructor: ->
    super "Sales", "sal", "graph"
    @sales = 2
    @averageDemand = 20

class FundraisingCard extends Card
  constructor: ->
    super "Fundraising", "fun", "dollar"
    @fundraising = 2