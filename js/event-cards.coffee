class EventCard
  constructor: (@name, @id ,@icon) ->
    @expiry = -1 #never expires
    @description = "An event occurred"
    @isRejectable = true
    @acceptText = "Accept"
    @rejectText = "Reject"
    @cost = 0
    @thresholds = {
      development: 0
      design: 0
      marketing: 0
      research: 0
      sales: 0
      fundraising: 0
      productivity: 0
      cash: 0
      equity: 0
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
    @acceptText = "Great"
    @rejectText = "Gross"
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
    @acceptText = "Milk it"
    @rejectText = "Youtube? No."
    @expiry = 3 #3 days after receipt
    @thresholds.marketing = 70

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing *= 2.5
    business.stats.marketing += 3
    business.stats.cash += 10

#research cards
class ProductMarketFitCard extends EventCard
  constructor: ->
    super "Product Market Fit", "res", "graph"
    @description = "If we make some changes, research says we can have a much better fit...."
    @acceptText = "Let's try"
    @rejectText = "I don't trust it"
    @expiry = 0
    @thresholds.research = 5

  tick: (business, tasks) ->
    super business, tasks
    business.stats.potentialMarketSize *= Math.round((Math.random() * (1.25 - 0.9)) + 0.9)

#fundraising cards
class MoneyFromDadCard extends EventCard
  constructor: ->
    super "$200 From Dad", "fun", "credit-card"
    @acceptText = "Accept"
    @rejectText = "Too Proud"
    @description = "Your Dad doesn't want you to starve. Or eat too much."
    @expiry = 0
    @thresholds.cash = -100

  hasBusinessMetConditions: (business) ->
    thresholdsMet = yes
    for stat, value of @thresholds
      if value != 0 and business.stats[stat] > value
        thresholdsMet = no
    return thresholdsMet

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 200

class MoneyFromDadCard_Generous extends EventCard
  constructor: ->
    super "$1000 From Dad", "fun", "credit-card"
    @acceptText = "Accept"
    @rejectText = "Too Proud"
    @description = "You're worrying your parents. Which does have some benefits?"
    @expiry = 0
    @thresholds.cash = -500

  hasBusinessMetConditions: (business) ->
    thresholdsMet = yes
    for stat, value of @thresholds
      if value != 0 and business.stats[stat] > value
        thresholdsMet = no
    return thresholdsMet

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 1000

class MoneyFromMomCard extends EventCard
  constructor: ->
    super "$250 From Mom", "fun", "credit-card"
    @acceptText = "Accept"
    @rejectText = "Too Proud"
    @description = "Your Mom bought you lunch. For a week."
    @expiry = 0
    @thresholds.cash = 100

  hasBusinessMetConditions: (business) ->
    thresholdsMet = yes
    for stat, value of @thresholds
      if value != 0 and business.stats[stat] > value
        thresholdsMet = no
    return thresholdsMet

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 250

class MoneyFromMomCard_Generous extends EventCard
  constructor: ->
    super "$750 From Mom", "fun", "credit-card"
    @acceptText = "Accept"
    @rejectText = "Too Proud"
    @description = "Turns out your Mom can still see your account balance. That was an awkward phone call."
    @expiry = 0
    @thresholds.cash = -1000

  hasBusinessMetConditions: (business) ->
    thresholdsMet = yes
    for stat, value of @thresholds
      if value != 0 and business.stats[stat] > value
        thresholdsMet = no
    return thresholdsMet

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 750

class CrowdfundingCampaignCard extends EventCard
  constructor: ->
    super "Kick my Lemons", "fun", "credit-card"
    @description = "Try a crowdfunding campaign? People say they want your lemonade. Or at least the t-shirt."
    @acceptText = "Go for it"
    @rejectText = "Tacky. No"
    @expiry = 0
    @thresholds.marketing = 15
    @thresholds.fundraising = 50

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += Math.round((Math.random() * (15000 - 2500)) + 2500)
    business.stats.marketing += 5

class CrowdfundingCampaignCard_B extends EventCard
  constructor: ->
    super "Lemons-A-Go-Go", "fun", "credit-card"
    @description = "I think this pitch video is pretty good?"
    @acceptText = "Go for it"
    @rejectText = "Tacky. No"
    @expiry = 5
    @thresholds.marketing = 7
    @thresholds.fundraising = 25

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.cash += Math.round((Math.random() * (200 - 10)) + 10)
    business.stats.marketing += 2

class SeedInvestmentCard extends EventCard
  constructor: ->
    super "Ignore the Horns", "fun", "credit-card"
    @description = "A lovely gentleman with a dashing goatee offered $20,000 for 20% equity. And some fine print."
    @acceptText = "Thanks!"
    @rejectText = "No way."
    @expiry = 0
    @thresholds.fundraising = 15
    @thresholds.equity = 20

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 20000
    business.stats.equity -= 20

class SeedInvestmentCard_B extends EventCard
  constructor: ->
    super "Thirsty Banker", "fun", "credit-card"
    @description = "An investment banker passed by, and needed to hide the booze on his breath. He sees an opportunity. For 20%."
    @acceptText = "Great"
    @rejectText = "Nope"
    @expiry = 0
    @thresholds.development = 15
    @thresholds.equity = 20

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 10000
    business.stats.equity -= 20


#sales cards
class GreatSalesPitchCard extends EventCard
  constructor: ->
    super "Silver Tongue", "sal", "comment-square"
    @description = "Your pitch is so practiced, even the mirror is thirsty."
    @isRejectable = false
    @expiry = 0
    @thresholds.sales = 3

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 5
    business.stats.sales += 5

class BrandAmbassadorCard extends EventCard
  constructor: ->
    super "Brand Ambassador", "sal", "musical-note"
    @description = "Turns out, 50 Cent's cousin's friend likes our lemonade! She's agreed to represent us for a few days. And $10,000."
    @acceptText = "Sign us up!"
    @rejectText = "Err ... no?"
    @expiry = 5
    @thresholds.marketing = 15
    @thresholds.sales = 25
    @thresholds.cash = 10000

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 2
      task.sales = task.sales * 1.5
    business.stats.marketing += 5
    business.stats.potentialMarketSize *= 1.25
    business.stats.cash -= 10000

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

class BloodLemonsCard extends EventCard
  constructor: ->
    super "Blood Lemons", "dev", "comment-square"
    @description = "Err, we should ethically source our lemons. A little more expensive, but ... Just don't ask."
    @acceptText = "Okay"
    @rejectText = "Mmm blood"
    @expiry = 0
    @thresholds.development = 10

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 5
    business.stats.potentialMarketSize *= 1.1
    business.stats.variableCostPerDay *= 1.2
