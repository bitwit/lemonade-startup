eventCards = [
  new PRAgentEventCard()
  new PRAgentEventCard_B()
  new BrandAmbassadorCard()
  new GreatSalesPitchCard()
  new ProductMarketFitCard()
  new GoneViralCardGood()
  new MoneyFromDadCard()
  new CrowdfundingCampaignCard()
  new SeedInvestmentCard()
  new CaffinatedLemonsCard()
  new BloodLemonsCard()
  new MoneyFromDadCard_Generous()
  new MoneyFromMomCard()
  new MoneyFromMomCard_Generous()
  new SeedInvestmentCard_B()
  new SeedInvestmentCard_C()
  new CrowdfundingCampaignCard_B()
  new FranchiseCard()
 # new FranchiseCard()
 # new FranchiseCard()
  new DowntownPermitCard()
  new SuburbanPermitCard()
  new SlickPackagingCard()
  new DesignAwardCard()
  new SuperSlickPackagingCard()
 # new GoneViralBadCard()
  new CrossPromotionCard()
  new BrandAmbassadorCard_B()
  new IntravenousLemonadeCard()
  new LemonadeEyedropsCard()
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

class BusinessObject

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
    averageDemand: 20
    potentialMarketSize: 100

  businessHistory: []
  dailyRevenueHistory: [] #stores the cashDelta for every day

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

  forecast: []

  constructor: ->
    @generateForecast(weatherCards)

  onDayStart: ->
    #to perform any start of day functions

  dayComplete: (day, onEventOccurence) ->

    #First tick assets, which can modify day cards
    if @assets.length > 0
      for i in [(@assets.length - 1)..0]
        asset = @assets[i]
        asset.tick @, day.tasks

    #Then merge the cards of the day to the business
    for card in day.tasks
      card.merge @

    #Search for new events to trigger
    didTriggerEvent = no
    for eventCard, i in eventCards
      if eventCard.hasBusinessMetConditions @
        didTriggerEvent = yes
        event = eventCards.splice(i, 1)[0]  # discarding this event from eventsCards[] for good
        onEventOccurence event  # announcing the event to the UI, which pauses the simulation timer until dismiss
        break

    #get the weather before calculating
    weather = @forecast.shift()
    numCustomers = @calculateDemand weather, day

    if numCustomers > @stats.potentialMarketSize
      numCustomers = @stats.potentialMarketSize

    #Standard impacts on the business
    stats = @stats
    cashDelta = 0
    if stats.fixedCostPerDay > 0
      cashDelta -= stats.fixedCostPerDay
    if stats.variableCostPerDay > 0
      cashDelta -= numCustomers * stats.variableCostPerDay
    cashDelta += numCustomers * day.price
    stats.cash = stats.cash + cashDelta

    @dailyRevenueHistory.push cashDelta

    #create history object
    dayHistory =
      cashDelta:cashDelta
      customerCount:numCustomers
      weather: clone weather
    dayHistory.weather.calculateTemperature()
    @businessHistory.push dayHistory

    @predictBusinessValue numCustomers
    @generateForecast(weatherCards) #add something new to the forecast
    return { dayHistory, didTriggerEvent }  # we inform the UI if an event was triggered so it knows whether to pause or not

  sprintComplete: (sprintNumber) ->
    #currently passing the number of the completed sprint only
    @setCosts(sprintNumber)
    @setCreditLimit()
    #if sprintNumber is 10 #GAME OVER!
     # @processEndGame()

  processEndGame: (victoryConditions) ->
    validConditions = []
    for condition in victoryConditions
      if condition.hasBusinessMetConditions(@)
        validConditions.push(condition)

    selectedCondition = validConditions[0]

    for i in [0...validConditions.length]
      if validConditions[i].priority > selectedCondition.priority
        selectedCondition = validConditions[i]

    return selectedCondition

  generateForecast: (weatherCards) ->
    cards = weatherCards.slice()
    while @forecast.length < 3
      shuffle(cards)
      @forecast.push cards.pop()

  setCosts: (sprintNumber) ->
    @stats.fixedCostPerDay += 50 * sprintNumber

  neutralPrice: ->
    #calculate market force, minimum 1
    marketForce = @stats.marketing + @stats.sales + @stats.design
    if marketForce <= 0
      marketForce = 1
    #calculate market clearing price and apply to demand
    neutralPrice = 1 + marketForce/100
    return neutralPrice

  calculateDemand: (weather,day) ->
    demand = @stats.averageDemand #get base demand
    demand *= weather.averageDemand #multiply by weather's affect on demand

    neutralPrice = @neutralPrice()
    if not (day.price is neutralPrice) and not (day.price is 0)
      ratio = neutralPrice / day.price
    else
      ratio = 10 # 10x multiplier on free lemonade

    demand *= ratio

    return demand

  setCreditLimit: ->
    stats = @stats
    newLimit = stats.cash/10 + @getRevenueHistory(7)

    if newLimit < 1000
      newLimit = 1000
    else if newLimit > 50000
      newLimit = 50000
    newLimit = newLimit - (newLimit % 1000)
    newLimit = Math.round(newLimit)
    if newLimit < 1000
      newLimit = 1000
    else if newLimit > 50000
      newLimit = 50000
    stats.creditLimit = newLimit

  doesPassFinancialCheck: ->
    if @stats.cash > 0 - @stats.creditLimit
      return true
    else
      return false

  setSprintModifiers: (sprintNumber) ->
    #the thought is to use these to increase difficulty as the game goes on, maybe?
    if sprintNumber > 3
      #do something?
    else

    if sprintNumber > 6
      #do something else?
    else

  predictBusinessValue: (numCustomers) ->
    estDayRevenue = ((@neutralPrice() - @stats.variableCostPerDay) * numCustomers) - @stats.fixedCostPerDay
    yearlyRevenue = estDayRevenue * 365
    @stats.projectedValue = yearlyRevenue

  getRevenueHistory: (interval) ->
    runningTotal = 0
    if @dailyRevenueHistory.length >= interval
      for i in [0...interval]
        runningTotal += @dailyRevenueHistory[@dailyRevenueHistory.length - (interval - i)]
    else if @dailyRevenueHistory.length is 0
      console.log("No entries in Daily Revenue History")
    else
      for entry in @dailyRevenueHistory
        runningTotal += entry

    return runningTotal
