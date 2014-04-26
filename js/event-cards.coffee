class EventCard
  constructor: (@name, @icon) ->
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

class PRAgentEventCard extends EventCard
  constructor: ->
    super "PR Agent", "rss"
    @description = "A PR Agent has agreed to help work with your team for the next few days"
    @expiry = 3 #3 days after receipt
    @thresholds.marketing = 2

  tick: (business, tasks) ->
    super business, tasks
    for task in tasks
      task.marketing = task.marketing * 1.5
    business.stats.marketing += 1
