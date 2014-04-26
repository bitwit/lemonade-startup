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
        event = eventCards.splice(i, 1)[0]
        businessObject.assets.push event
        $rootScope.announceEvent event

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

    day.announce "$" + cashDelta
    businessObject.generateForecast() #add something new to the forecast

    return didTriggerEvent

  businessObject.generateForecast = ->
    while businessObject.forecast.length < 3
      shuffle(weatherCards)
      businessObject.forecast.push weatherCards.pop()
    weatherCards = weatherCards.concat businessObject.forecast

  businessObject.generateForecast()
  $rootScope.game = businessObject
  console.log 'starting forecast', businessObject.forecast
  return businessObject
]

