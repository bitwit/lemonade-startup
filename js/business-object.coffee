appModule.service "BusinessObject", ["$rootScope", ($rootScope) ->
  eventCards = [
    new PRAgentEventCard()
    new BrandAmbassadorCard()
    new GreatSalesPitchCard()
    new ProductMarketFitCard()
    new GoneViralCardGood()
    new MoneyFromDadCard()
    new CrowdfundingCampaignCard()
    new SeedInvestmentCard()
    new CaffinatedLemonsCard()
  ]
  weatherCards = [
    new HeatWaveWeatherCard()
    new GoodWeatherCard()
    new RainyWeatherCard()
    new ColdWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
    new AverageWeatherCard()
  ]

  victoryConditions = [
    new StagnantEnding()
    new BankruptEnding()
    new AcquiredEnding()
    new BootstrapEnding()
    new HostileTakeoverEnding()
    new SoftHostileTakeoverEnding()
    new ALittleBetterEnding()
  ]

  businessHistory = []
  dailyRevenueHistory = [] #stores the cashDelta for every day
  $rootScope.forecast = []

  businessObject =
    stats:
      cash: 50
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
      fixedCostPerDay: 5
      variableCostPerDay: 0.20
      averageDemand: 200
      potentialMarketSize: 1000
    flags:
      doesHaveAvailableFunds: true
      doesHaveAvailableEquity: true
      playerHasMajorityEquity: true
      playerHasTotalOwnership: true
      cashOnHandIsPositive: true
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
      playerHasSoldOut: false

    tracking:
      highestPrice: 0
      lowestPrice: 0
      mostCustomersInOneDay: 0
      totalCustomers: 0
      totalRevenue: 0
      mostCashOnHand: 0
      leastCashOnHand: 0
    assets: []

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
        #businessObject.assets.unshift event  # putting it into assets (where it can expire, or persist indefinitely)
        $rootScope.$broadcast 'eventCardOccured', event  # announcing the event to the UI, which pauses the simulation timer until dismiss
        break

    #get the weather before calculating
    weather = $rootScope.forecast.shift()
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

    dailyRevenueHistory.push cashDelta

    #create history object
    dayHistory = clone businessObject
    dayHistory.cashDelta = cashDelta
    dayHistory.weather = clone weather
    dayHistory.weather.calculateTemperature()
    businessHistory.push dayHistory
    console.log 'biz history', businessHistory

    console.log(dailyRevenueHistory)

    day.announce dayHistory

    businessObject.predictBusinessValue()
    businessObject.generateForecast() #add something new to the forecast

    return didTriggerEvent  # we inform the UI if an event was triggered so it knows whether to pause or not

  businessObject.sprintComplete = (sprintNumber) ->
    #currently passing the number of the completed sprint only
    console.log("Sprint #{sprintNumber} completed")
    businessObject.setCosts(sprintNumber)
    businessObject.setCreditLimit()
    #if sprintNumber is 10 #GAME OVER!
     # businessObject.processEndGame()

  businessObject.processEndGame = ->
    console.log("Game over!")

    #stats = businessObject.stats
    #flags = businessObject.flags

    validConditions = []
    for condition in victoryConditions
      if condition.hasBusinessMetConditions(businessObject)
        validConditions.push(condition)

    selectedCondition = validConditions[0]

    for i in [0...validConditions.length]
      if validConditions[i].priority > selectedCondition.priority
        selectedCondition = validConditions[i]

    return selectedCondition

    #needs to return a card


  businessObject.generateForecast = ->
    while $rootScope.forecast.length < 3
      shuffle(weatherCards)
      $rootScope.forecast.push weatherCards.pop()
    weatherCards = weatherCards.concat $rootScope.forecast

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

  businessObject.assessBusinessState = ->
    stats = businessObject.stats
    flags = businessObject.flags

    if stats.cash > 0
      flags.cashOnHandIsPositive = true
    else
      flags.cashOnHandIsPositive = false

    if stats.cash + stats.creditLimit > 0
      flags.doesHaveAvailableFunds = true
      flags.isBroke = false
    else
      flags.doesHaveAvailableFunds = false
      flags.isBroke = true

    if stats.equity > 0
      flags.doesHaveAvailableEquity = true
    else
      flags.doesHaveAvailableEquity = false

    if stats.equity > 50
      flags.playerHasMajorityEquity = true
    else
      flags.playerHasMajorityEquity = false

    if stats.equity >= 100
      flags.playerHasTotalOwnership = true
    else
      flags.playerHasTotalOwnership = false

    if stats.cash > 1000000
      flags.hasPassedHighThreshold_Cash = true
    else
      flags.hasPassedHighThreshold_Cash = false

    if stats.research > 100
      flags.hasPassedHighThreshold_Research = true

    if stats.development > 100
      flags.hasPassedHighThreshold_Development = true

    if stats.design > 100
      flags.hasPassedHighThreshold_Design = true

    if stats.marketing > 100
      flags.hasPassedHighThreshold_Marketing = true

    if stats.sales > 100
      flags.hasPassedHighThreshold_Sales = true

    if stats.fundraising > 100
      flags.hasPassedHighThreshold_Fundraising = true

    if stats.potentialMarketSize > 100000
      flags.hasPassedHighThreshold_MarketSize = true

    if stats.cash > 0 and stats.cash < 100000
      flags.isUnderLowThreshold_Cash = true
    else
      flags.isUnderLowThreshold_Cash = false

    if stats.equity < 50
      flags.playerHasSoldOut = true
    else
      flags.playerHasSoldOut = false

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
    if dailyRevenueHistory.length >= interval
      for i in [0...interval]
        #console.log("entry", i)
        runningTotal += dailyRevenueHistory[dailyRevenueHistory.length - (interval - i)]
    else if dailyRevenueHistory.length is 0
      console.log("No entries in Daily Revenue History")
    else
      #console.log("fewer entries than interval", dailyRevenueHistory.length)
      for entry in dailyRevenueHistory
        runningTotal += entry

    console.log("runningtotal", runningTotal)
    return runningTotal

  businessObject.generateForecast()
  $rootScope.game = businessObject
  console.log 'starting forecast', $rootScope.forecast
  return businessObject
]

