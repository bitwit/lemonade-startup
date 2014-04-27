class EventCard
  constructor: (@name, @id ,@icon) ->
    @expiry = -1 #never expires
    @description = "An event occurred"
    @thresholds = {
      development: 0
      design: 0
      marketing: 0
      research: 0
      sales: 0
      fundraising: 0
      productivity: 0
      cash: 0
    }

  hasBusinessMetConditions: (business) ->
    thresholdsMet = yes
    for stat, value of @thresholds
      if value != 0 and business.stats[stat] < value
        thresholdsMet = no
    return thresholdsMet

  tick: (business, tasks) ->
    if @expiry is -1
      return true
    else
      @expiry--
      if @expiry <= 0
        index = business.assets.indexOf @
        business.assets.splice index, 1


#marketing cards
class PRAgentEventCard extends EventCard
  constructor: ->
    super "PR Agent", "mkt", "rss"
    @description = "A PR Agent has agreed to help work with your team for the next few days"
    @expiry = 3 #3 days after receipt
    @thresholds.marketing = 2

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 1.5
    business.stats.marketing += 1

class GoneViralCardGood extends EventCard
  constructor: ->
    super "Gone Viral", "mkt", "rss"
    @description = "A youtube video you made now has 10,000,000 views. That has to be good for something, right?"
    @expiry = 3 #3 days after receipt
    @thresholds.marketing = 3

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 1.5
    business.stats.marketing += 3
    business.stats.cash += 10

#research cards
class ProductMarketFitCard extends EventCard
  constructor: ->
    super "Product Market Fit", "res", "graph"
    @description = "Word from our market research team is looking good..."
    @expiry = 0
    @thresholds.research = 5

  tick: (business, tasks) ->
    super business, tasks
    business.stats.potentialMarketSize += 1000

#fundraising cards
class MoneyFromDadCard extends EventCard
  constructor: ->
    super "$200 From Dad", "fun", "credit-card"
    @description = "Your Dad doesn't want you to starve. Or eat too much."
    @expiry = 0
    @thresholds.cash = 100

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 200

class CrowdfundingCampaignCard extends EventCard
  constructor: ->
    super "Kick my Lemons", "fun", "credit-card"
    @description = "Our crowdfunding campaign took off! People really want your lemonade. Or at least the t-shirt."
    @expiry = 0
    @thresholds.marketing = 5
    @thresholds.fundraising = 10

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 5000
    business.stats.marketing += 5

class SeedInvestmentCard extends EventCard
  constructor: ->
    super "Ignore the Horns", "fun", "credit-card"
    @description = "A lovely gentleman with a dashing goatee offered some seed money..."
    @expiry = -1
    @thresholds.fundraising = 15

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 20000
    business.stats.equity -= 10

#sales cards
class GreatSalesPitchCard extends EventCard
  constructor: ->
    super "Silver Tongue", "sal", "comment-square"
    @description = "Your pitch is so practiced, even the mirror is thirsty."
    @expiry = 0
    @thresholds.sales = 3

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 5

class BrandAmbassadorCard extends EventCard
  constructor: ->
    super "Brand Ambassador", "sal", "musical-note"
    @description = "Turns out, 50 Cent's cousin's friend likes our lemonade! She's agreed to represent us for a few days."
    @expiry = 5
    @thresholds.marketing = 5
    @thresholds.sales = 5

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 2
      task.sales = task.sales * 1.5
    business.stats.marketing += 5
    business.stats.potentialMarketSize += 1000

#development cards
class CaffinatedLemonsCard extends EventCard
  constructor: ->
    super "Caffinated Lemons", "dev", "comment-square"
    @description = "How diddddn't we thinkkk of thss bbbeforre?? Why wn'tttt mmy knee stop shhhhaking?"
    @expiry = 0
    @thresholds.development = 10

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 5
    business.stats.sales += 1
