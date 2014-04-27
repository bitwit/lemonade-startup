class EventCard
  constructor: (@name, @id ,@icon) ->
    @expiry = -1 #never expires
    @description = "An event occurred"
    @isRejectable = true
    @acceptText = "Accept"
    @rejectText = "Reject"
    @cost = 0
    @equity = 0
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
    @rejectText = "Nah"
    @expiry = 3 #3 days after receipt
    @thresholds.marketing = 25

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 1.5
    business.stats.marketing += 1

class PRAgentEventCard_B extends EventCard
  constructor: ->
    super "PR Agent", "mkt", "rss"
    @description = "A PR Agent has agreed to help work with your team for the next few days"
    @acceptText = "Great"
    @rejectText = "Nah"
    @expiry = 5 #3 days after receipt
    @thresholds.marketing = 50

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 1.4
    business.stats.marketing += 2
    business.stats.averageDemand += 20


class GoneViralCardGood extends EventCard
  constructor: ->
    super "Going Viral?", "mkt", "rss"
    @description = "A friend has offered to make you an auto-tuned Youtube music video."
    @acceptText = "Milk it"
    @rejectText = "Negative"
    @expiry = 3 #3 days after receipt
    @thresholds.marketing = 10

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
    @description = "After extensive customer research you have an idea..."
    @acceptText = "Try it"
    @rejectText = "Not ready"
    @expiry = -1
    @thresholds.research = 20

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

  hasBusinessMetConditions: (business) ->
    if business.stats.cash < -100
      return yes
    return no

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

  hasBusinessMetConditions: (business) ->
    if business.stats.cash < -500
      return yes
    return no

  tick: (business, tasks) ->
    super business, tasks
    business.stats.cash += 1000

class MoneyFromMomCard extends EventCard
  constructor: ->
    super "$250 From Mom", "fun", "credit-card"
    @acceptText = "Accept"
    @rejectText = "Too Proud"
    @description = "Your Mom is offering you lunch. For a week."
    @expiry = 0
    @thresholds.cash = 100

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

  hasBusinessMetConditions: (business) ->
    if business.stats.cash < -1000
      return yes
    return no

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
    super "Perfect Sales Pitch", "sal", "comment-square"
    @description = "You've practiced your elevator speech and it's ready."
    @isRejectable = false
    @expiry = 0
    @thresholds.sales = 20
    @acceptText = "Use it"
    @rejectText = "Too shy"

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 5
    business.stats.sales += 5

class DowntownPermitCard extends EventCard
  constructor: ->
    super "Downtown Vending Permit", "sal", "comment-square"
    @description = "A permit opened up for a prime corner downtown. Want it? Only $20000...."
    @isRejectable = false
    @expiry = -1
    @thresholds.sales = 60
    @thresholds.cash = 20000
    @cost = 20000

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing -= 3
    business.stats.sales += 5
    business.stats.potentialMarketSize *= 1.07
    business.stats.fixedCostPerDay *= 1.05

class SuburbanPermitCard extends EventCard
  constructor: ->
    super "Suburban Vending Permit", "sal", "comment-square"
    @description = "A permit opened up for a spot in a residential neighbourhood. Want it? Only $10000..."
    @isRejectable = false
    @expiry = -1
    @thresholds.sales = 40
    @thresholds.cash = 10000

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing -= 5
    business.stats.sales += 5
    business.stats.potentialMarketSize *= 1.03
    business.stats.fixedCostPerDay *= 1.02

class FranchiseCard extends EventCard
  constructor: ->
    super "Second Cart Life", "sal", "comment-square"
    @description = "We could open another cart. It would only cost about $25000, and 10%"
    @isRejectable = false
    @expiry = -1
    @thresholds.sales = 40
    @thresholds.marketing = 40
    @thresholds.cash = 25000
    @thresholds.equity = 10
    @cost = 25000
    @equity = 10

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 2
    business.stats.sales += 2
    business.stats.potentialMarketSize *= 1.10
    business.stats.fixedCostPerDay *= 1.07

class BrandAmbassadorCard extends EventCard
  constructor: ->
    super "Brand Ambassador", "sal", "musical-note"
    @description = "Rapper 50 Cent's cousin likes our lemonade! She's agreed to promote us for $10,000."
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
    business.stats.cash -= 2000

class BrandAmbassadorCard_B extends EventCard
  constructor: ->
    super "Brand Ambassador", "sal", "musical-note"
    @description = "For 10%, Ice-T's manager's favourite dog groomer will do some promotion for us!"
    @acceptText = "Do it!"
    @rejectText = "Nope"
    @expiry = 10
    @thresholds.marketing = 50
    @thresholds.sales = 25
    @thresholds.equity = 10

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 2
      task.sales = task.sales * 1.5
    business.stats.marketing += 5
    business.stats.potentialMarketSize *= 1.1
    business.stats.equity -= 1

class CrossPromotionCard extends EventCard
  constructor: ->
    super "Cross Promotion", "sal", "musical-note"
    @description = "Know what goes with lemonade? Salmon! They want to co-market with us, for 5%."
    @acceptText = "Yum"
    @rejectText = "Gross"
    @expiry = 3
    @thresholds.marketing = 8
    @thresholds.sales = 7
    @thresholds.equity = 5

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 1.1
      task.sales = task.sales * 1.1
    business.stats.marketing += 7
    business.stats.potentialMarketSize *= 1.1
    business.stats.equity -= 5

#development cards
class CaffinatedLemonsCard extends EventCard
  constructor: ->
    super "Caffinated Lemons", "dev", "beaker"
    @description = "You can now infuse your lemons with caffeine. Do it?"
    @acceptText = "Oh yeah!"
    @rejectText = "Nope"
    @expiry = -1
    @thresholds.development = 30

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 1
    business.stats.sales += 1
    business.stats.variableCostPerDay *= 1.03
    business.stats.averageDemand += 20

class LemonadeEyedropsCard extends EventCard
  constructor: ->
    super "Lemonade Eyedrops", "dev", "eyedropper"
    @description = "You haven't tried them yet, but maybe they'll sell."
    @acceptText = "Do it"
    @rejectText = "Uh..."
    @expiry = -1
    @thresholds.development = 20

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing -= 1
    business.stats.sales -= 1
    business.stats.variableCostPerDay *= 1.02

class IntravenousLemonadeCard extends EventCard
  constructor: ->
    super "Intravenous Lemonade", "dev", "eyedropper"
    @description = "Now your customers never have to stop drinking lemonade!"
    @acceptText = "Okay"
    @rejectText = "No"
    @expiry = -1
    @thresholds.development = 30

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 15
    business.stats.sales += 10
    business.stats.variableCostPerDay *= 1.04

class BloodLemonsCard extends EventCard
  constructor: ->
    super "Blood Lemons", "dev", "comment-square"
    @description = "You've sourced some cheap lemons from abroad and they taste fine. Use them?"
    @acceptText = "Oh yeah!"
    @rejectText = "Nope"
    @expiry = -1
    @thresholds.development = 10

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing -= 2
    business.stats.potentialMarketSize *= 1.1
    business.stats.variableCostPerDay *= 0.98

class GoneViralBadCard extends EventCard
  constructor: ->
    super "Gone Viral", "dev", "bug"
    @description = "Like actually viral. We need a product recall."
    @acceptText = "Meh"
    @rejectText = "Do it"
    @expiry = 0
    @thresholds.development = 5

  hasBusinessMetConditions: (business) ->
    thresholdsMet = yes
    for stat, value of @thresholds
      if value != 0 and business.stats[stat] > value
        thresholdsMet = no
    return thresholdsMet


  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing -= 10
    business.stats.sales -= 10
    business.stats.potentialMarketSize *= 0.75


class SlickPackagingCard extends EventCard
  constructor: ->
    super "Slick Packaging", "des", "comment-square"
    @description = "You've been polishing your Photoshop skills and have a new packaging concept. Use it?"
    @acceptText = "Sure"
    @rejectText = "Meh"
    @expiry = -1
    @thresholds.design = 18

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 2
    business.stats.design += 2

class SuperSlickPackagingCard extends EventCard
  constructor: ->
    super "Super Slick Packaging", "des", "aperture"
    @description = "Don't you think this looks cooler?"
    @acceptText = "Sure"
    @rejectText = "Meh"
    @expiry = 0
    @thresholds.design = 30

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 10
    business.stats.variableCostPerDay *= 1.02

class DesignAwardCard extends EventCard
  constructor: ->
    super "Design Award", "des", "badge"
    @description = "So, we won a design award. But we need to pay to accept it. Worth $2500?"
    @acceptText = "Sure"
    @rejectText = "No way"
    @expiry = 0
    @thresholds.design = 40

  tick: (business, tasks) ->
    super business, tasks
    business.stats.marketing += 5
    business.stats.sales += 1
