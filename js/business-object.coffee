#+ Jonas Raoni Soares Silva
#@ http://jsfromhell.com/array/shuffle [v1.0]
shuffle = (array) ->
  counter = array.length;
  #While there are elements in the array
  while (counter > 0)
      #Pick a random index
      index = Math.floor(Math.random() * counter)
      #Decrease counter by 1
      counter--
      #And swap the last element with it
      temp = array[counter]
      array[counter] = array[index]
      array[index] = temp
  return array;

appModule.service "BusinessObject", ["$rootScope", ($rootScope) ->
  eventCards = [
    new PRAgentEventCard()
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
      projectedValue: 0
      development: 0
      design: 0
      marketing: 0
      research: 0
      sales: 0
      fundraising: 0
      productivity: 0
      fixedCostPerDay: 500
      variableCostPerDay: 0.20
      averageDemand: 200
    assets: []
    dailyRevenueHistory: [] #stores the cashDelta for every day

  businessObject.dayComplete = (day) ->
    console.log 'day complete', day

    #First tick assets, which can modify day cards
    for asset in businessObject.assets
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
        $rootScope.announceEvent event  # announcing the event to the UI, which pauses the simulation timer until dismiss

    #get the weather before calculating
    weather = businessObject.forecast.shift()

    #Standard impacts on the business
    stats = businessObject.stats
    cashDelta = 0
    cashDelta -= stats.fixedCostPerDay
    cashDelta -= stats.averageDemand * weather.averageDemand * stats.variableCostPerDay
    cashDelta += stats.averageDemand * weather.averageDemand * parseFloat(day.price)
    cashDelta = parseFloat(cashDelta).toFixed(2)
    stats.cash = (Number(stats.cash) + Number(cashDelta)).toFixed(2)
    fCashDelta = Number(cashDelta).toFixed(2)

    businessObject.dailyRevenueHistory.push fCashDelta
    console.log(businessObject.dailyRevenueHistory)

    day.announce "$" + cashDelta

    businessObject.predictBusinessValue()
    businessObject.generateForecast() #add something new to the forecast

    return didTriggerEvent  # we inform the UI if an event was triggered so it knows whether to pause or not

  businessObject.sprintComplete = (sprintNumber) ->
    #currently passing the number of the completed sprint only
    console.log("Sprint #{sprintNumber} completed")

  businessObject.generateForecast = ->
    while businessObject.forecast.length < 3
      shuffle(weatherCards)
      businessObject.forecast.push weatherCards.pop()
    weatherCards = weatherCards.concat businessObject.forecast

  businessObject.predictBusinessValue = ->
    newValue = 0
    #cash on hand + previous week's revenue * factor + marketing * research * ___ + average demand * factor - fundraising * factor

    stats = businessObject.stats
    newValue = stats.cash + (businessObject.getRevenueHistory(7) * 52) + (stats.averageDemand * stats.marketing * stats.development) - (stats.fundraising * -0.1)

    stats.projectedValue = newValue

  businessObject.getRevenueHistory = (interval) ->
    runningTotal = 0
    if businessObject.dailyRevenueHistory.length >= interval
      for i in [0...interval]
        console.log("entry", i)
        runningTotal += businessObject.dailyRevenueHistory[businessObject.dailyRevenueHistory.length -1 - (interval - i)]
    else if businessObject.dailyRevenueHistory.length is 0
      console.log("No entries in Daily Revenue History")
    else
      console.log("fewer entries than interval", businessObject.dailyRevenueHistory.length)
      for entry in businessObject.dailyRevenueHistory
        runningTotal += entry

    console.log("runningtotal", runningTotal)
    return runningTotal

  businessObject.generateForecast()
  $rootScope.game = businessObject
  console.log 'starting forecast', businessObject.forecast
  return businessObject
]

