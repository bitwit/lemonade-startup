appModule.service "BusinessObject", ["$rootScope", ($rootScope) ->
  eventCards = [
    new PRAgentEventCard()
    new BrandAmbassadorCard()
    new GreatSalesPitchCard()
    new ProductMarketFitCard()
    new GoneViralCardGood()
    new MoneyFromDadCard()
    new CrowdfundingCampaignCard()
  ]
  weatherCards = [
    new HeatWaveWeatherCard()
    new GoodWeatherCard()
    new RainyWeatherCard()
    new ColdWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
  ]

  businessObject =
    forecast: []
    stats:
      cash: 50000
      creditLimit: 1000
      equity: 100
      projectedValue: -1000
      development: 0
      design: 0
      marketing: 0
      research: 0
      sales: 0
      fundraising: 0
      productivity: 0
      fixedCostPerDay: 50
      variableCostPerDay: 0.20
      averageDemand: 200
      potentialMarketSize: 1000
    assets: []
    dailyRevenueHistory: [] #stores the cashDelta for every day

  businessObject.onDayStart = ->
    #to perform any start of day functions

  businessObject.dayComplete = (day) ->
    console.log 'day complete', day

    #First tick assets, which can modify day cards
    if businessObject.assets.length > 0
      for i in [(businessObject.assets.length - 1)..0]
        console.log 'get object', i
        asset = businessObject.assets[i]
        asset.tick businessObject, day.tasks

    #Then merge the cards of the day to the business
    for card in day.tasks
      card.merge businessObject

    #Search for new events to trigger
    didTriggerEvent = no
    for eventCard, i in eventCards
      if eventCard.hasBusinessMetConditions businessObject
        didTriggerEvent = yes
        event = eventCards.splice(i, 1)[0]  # discarding this event from eventsCards[] for good
        businessObject.assets.push event  # putting it into assets (where it can expire, or persist indefinitely)
        $rootScope.$broadcast 'eventCardOccured', event  # announcing the event to the UI, which pauses the simulation timer until dismiss
        break

    #get the weather before calculating
    weather = businessObject.forecast.shift()
    businessObject.stats.averageDemand = businessObject.calculateDemand(weather,day)
    numCustomers = businessObject.stats.averageDemand
    if numCustomers > businessObject.stats.potentialMarketSize
      numCustomers = businessObject.stats.potentialMarketSize
    console.log("Number of Customers:",numCustomers)
    #Standard impacts on the business
    stats = businessObject.stats
    cashDelta = 0
    cashDelta -= stats.fixedCostPerDay
    cashDelta -= numCustomers * stats.variableCostPerDay
    cashDelta += numCustomers * day.price
    stats.cash = stats.cash + cashDelta

    businessObject.dailyRevenueHistory.push cashDelta
    console.log(businessObject.dailyRevenueHistory)

    day.announce cashDelta

    businessObject.predictBusinessValue()
    businessObject.generateForecast() #add something new to the forecast

    return didTriggerEvent  # we inform the UI if an event was triggered so it knows whether to pause or not

  businessObject.sprintComplete = (sprintNumber) ->
    #currently passing the number of the completed sprint only
    console.log("Sprint #{sprintNumber} completed")
    businessObject.setCosts(sprintNumber)
    businessObject.setCreditLimit()

  businessObject.generateForecast = ->
    while businessObject.forecast.length < 3
      shuffle(weatherCards)
      businessObject.forecast.push weatherCards.pop()
    weatherCards = weatherCards.concat businessObject.forecast

  businessObject.setCosts = (sprintNumber) ->
    console.log("Updating fixed costs")
    stats = businessObject.stats
    stats.fixedCostPerDay += 50 * sprintNumber

  businessObject.calculateDemand = (weather,day) ->
    stats = businessObject.stats
    demand = 0
    marketForce = (stats.marketing * 2 + stats.development + stats.design * 2 + stats.research * 2)
    if marketForce <= 0
      marketForce = 1
    neutralPrice = 1 + marketForce/100
    console.log("market force",marketForce)
    console.log("Neutral price",neutralPrice)
    priceDiff = 0
    console.log("Price",day.price)
    if day.price > 0
      priceDiff = neutralPrice/day.price
      console.log("price diff:",priceDiff)
    else if day.price < 0
      priceDiff = neutralPrice/day.price
      console.log("price diff:",priceDiff)
    else
      priceDiff = 1
      console.log("price diff:",priceDiff)

    console.log("weather effect", weather.averageDemand)
    demand = stats.potentialMarketSize * (marketForce/100) * weather.averageDemand * priceDiff
    if priceDiff < 0.5
      demand *= 0.5 #additional penalty for overpricing.

    if priceDiff < 0.2
      demand *= 0.1 #further penalty for crazy overpricing

    console.log("demand",demand)

    return demand

  businessObject.setCreditLimit = ->
    stats = businessObject.stats
    newLimit = stats.cash/10 + businessObject.getRevenueHistory(7)

    if newLimit < 1000
      newLimit = 1000
    else if newLimit > 50000
      newLimit = 50000
    console.log("limit",newLimit % 1000)
    console.log("new limit",newLimit)
    newLimit = newLimit - (newLimit % 1000)
    newLimit = Math.round(newLimit)
    console.log("new limit",newLimit)
    if newLimit < 1000
      newLimit = 1000
    else if newLimit > 50000
      newLimit = 50000
    stats.creditLimit = newLimit

  businessObject.doesPassFinancialCheck = ->
    stats = businessObject.stats
    if stats.cash > 0 - stats.creditLimit
      return true
    else
      return false

  businessObject.setSprintModifiers = (sprintNUmber) ->
    #the thought is to use these to increase difficulty as the game goes on, maybe?
    if sprintNUmber > 3
      #do something?
    else

    if sprintNUmber > 6
      #do something else?
    else

  businessObject.predictBusinessValue = ->
    newValue = 0
    #cash on hand + previous week's revenue * factor + marketing * research * ___ + average demand * factor - fundraising * factor

    stats = businessObject.stats
    console.log("Current Stats:")
    console.log("average demand:",stats.averageDemand)
    console.log("fixed costs:",stats.fixedCostPerDay)
    console.log("variable costs:",stats.variableCostPerDay)
    #set modifiers
    marketingModifier = stats.marketing + 1
    developmentModifier = stats.development + 1
    researchModifier = stats.research + 1
    #perform actual calculation
    newValue = stats.cash + (businessObject.getRevenueHistory(7) * 52 * 0.25) + (stats.averageDemand * marketingModifier * developmentModifier) + (researchModifier * developmentModifier) + (stats.fundraising * -0.1)
    #update value
    stats.projectedValue = newValue

  businessObject.getRevenueHistory = (interval) ->
    runningTotal = 0
    if businessObject.dailyRevenueHistory.length >= interval
      for i in [0...interval]
        #console.log("entry", i)
        runningTotal += businessObject.dailyRevenueHistory[businessObject.dailyRevenueHistory.length - (interval - i)]
    else if businessObject.dailyRevenueHistory.length is 0
      console.log("No entries in Daily Revenue History")
    else
      #console.log("fewer entries than interval", businessObject.dailyRevenueHistory.length)
      for entry in businessObject.dailyRevenueHistory
        runningTotal += entry

    console.log("runningtotal", runningTotal)
    return runningTotal

  businessObject.generateForecast()
  $rootScope.game = businessObject
  console.log 'starting forecast', businessObject.forecast
  return businessObject
]

