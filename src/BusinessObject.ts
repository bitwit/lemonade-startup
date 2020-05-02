import { EventCard } from './cards/event-cards'
import { shuffle, clone } from './utilities'
import * as VictoryConditions from './cards/victory-conditions'
import * as EventCards from './cards/event-cards'
import { Day } from './classes/Day'
import * as WeatherCards from './cards/weather-cards'

const victoryConditions = [
  new VictoryConditions.StagnantEnding(),
  new VictoryConditions.BankruptEnding(),
  new VictoryConditions.AcquiredEnding(),
  new VictoryConditions.BootstrapEnding(),
  new VictoryConditions.HostileTakeoverEnding(),
  new VictoryConditions.SoftHostileTakeoverEnding(),
  new VictoryConditions.ALittleBetterEnding()
]

const weatherCards = [
  new WeatherCards.HeatWaveWeatherCard(),
  new WeatherCards.GoodWeatherCard(),
  new WeatherCards.RainyWeatherCard(),
  new WeatherCards.ColdWeatherCard(),
  new WeatherCards.AverageWeatherCard(),
  new WeatherCards.AverageWeatherCard(),
  new WeatherCards.AverageWeatherCard()
]

const eventCards = [
  new EventCards.PRAgentEventCard(),
  new EventCards.PRAgentEventCard_B(),
  new EventCards.BrandAmbassadorCard(),
  new EventCards.GreatSalesPitchCard(),
  new EventCards.ProductMarketFitCard(),
  new EventCards.GoneViralCardGood(),
  new EventCards.MoneyFromDadCard(),
  new EventCards.CrowdfundingCampaignCard(),
  new EventCards.SeedInvestmentCard(),
  new EventCards.CaffinatedLemonsCard(),
  new EventCards.BloodLemonsCard(),
  new EventCards.MoneyFromDadCard_Generous(),
  new EventCards.MoneyFromMomCard(),
  new EventCards.MoneyFromMomCard_Generous(),
  new EventCards.SeedInvestmentCard_B(),
  new EventCards.SeedInvestmentCard_C(),
  new EventCards.CrowdfundingCampaignCard_B(),
  new EventCards.FranchiseCard(),
  new EventCards.DowntownPermitCard(),
  new EventCards.SuburbanPermitCard(),
  new EventCards.SlickPackagingCard(),
  new EventCards.DesignAwardCard(),
  new EventCards.SuperSlickPackagingCard(),
  new EventCards.CrossPromotionCard(),
  new EventCards.BrandAmbassadorCard_B(),
  new EventCards.IntravenousLemonadeCard(),
  new EventCards.LemonadeEyedropsCard(),
]

class BusinessStats {
  cash: number = 50
  creditLimit: number = 1000
  equity: number = 100
  projectedValue: number = -1000
  development: number = 0
  design: number = 0
  marketing: number = 0
  research: number = 0
  sales: number = 0
  fundraising: number = 0
  productivity: number = 0
  fixedCostPerDay: number = 5
  variableCostPerDay: number = 0.20
  averageDemand: number = 20
  potentialMarketSize: number = 100
}

class BusinessFlags {
  doesHaveAvailableFunds: boolean = true
  doesHaveAvailableEquity: boolean = true
  playerHasMajorityEquity: boolean = true
  playerHasTotalOwnership: boolean = true
  cashOnHandIsPositive: boolean = true
  hasPassedHighThreshold_Cash: boolean = false
  hasPassedHighThreshold_Research: boolean = false
  hasPassedHighThreshold_Development: boolean = false
  hasPassedHighThreshold_Design: boolean = false
  hasPassedHighThreshold_Marketing: boolean = false
  hasPassedHighThreshold_Sales: boolean = false
  hasPassedHighThreshold_Fundraising: boolean = false
  hasPassedHighThreshold_MarketSize: boolean = false
  isBroke: boolean = false
  isUnderLowThreshold_Cash: boolean = false
  playerHasSoldOut: boolean = false
}

export class BusinessObject {
  stats: BusinessStats = new BusinessStats()
  flags: BusinessFlags = new BusinessFlags()

  assets: EventCard[] = []
  forecast: any[] = []
  businessHistory: any[] = []
  dailyRevenueHistory: any[] = []

  constructor() {
    this.generateForecast(weatherCards)
  }

  dayComplete(day: Day, onEventOccurence: (event: EventCard) => void ) {
    document.addEventListener
    var asset, card, cashDelta, dayHistory, didTriggerEvent, event, eventCard, i, numCustomers, stats, weather, _i, _j, _k, _len, _len1, _ref, _ref1;
    if (this.assets.length > 0) {
      for (i = _i = _ref = this.assets.length - 1; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
        asset = this.assets[i];
        asset.tick(this, day.tasks);
      }
    }
    _ref1 = day.tasks;
    for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
      card = _ref1[_j];
      card.merge(this);
    }
    didTriggerEvent = false;
    for (i = _k = 0, _len1 = eventCards.length; _k < _len1; i = ++_k) {
      eventCard = eventCards[i];
      if (eventCard.hasBusinessMetConditions(this)) {
        didTriggerEvent = true;
        event = eventCards.splice(i, 1)[0];
        onEventOccurence(event);
        break;
      }
    }
    weather = this.forecast.shift();
    numCustomers = this.calculateDemand(weather, day);
    if (numCustomers > this.stats.potentialMarketSize) {
      numCustomers = this.stats.potentialMarketSize;
    }
    stats = this.stats;
    cashDelta = 0;
    if (stats.fixedCostPerDay > 0) {
      cashDelta -= stats.fixedCostPerDay;
    }
    if (stats.variableCostPerDay > 0) {
      cashDelta -= numCustomers * stats.variableCostPerDay;
    }
    cashDelta += numCustomers * day.price;
    stats.cash = stats.cash + cashDelta;
    this.dailyRevenueHistory.push(cashDelta);
    dayHistory = {
      cashDelta: cashDelta,
      customerCount: numCustomers,
      weather: clone(weather)
    };
    dayHistory.weather.calculateTemperature();
    this.businessHistory.push(dayHistory);
    this.predictBusinessValue(numCustomers);
    this.generateForecast(weatherCards);
    return {
      dayHistory: dayHistory,
      didTriggerEvent: didTriggerEvent
    };
  };

  sprintComplete(sprintNumber: number) {
    this.setCosts(sprintNumber);
    return this.setCreditLimit();
  }

  processEndGame() {
    let validConditions: VictoryConditions.VictoryCondition[] = []
    for(let condition of victoryConditions) {
      if(condition.hasBusinessMetConditions(this)) {
        validConditions.push(condition)
      }
    }
    let selectedCondition = validConditions[0]
    for(let condition of validConditions) {
      if(condition.priority > selectedCondition.priority) {
        selectedCondition = condition
      }
    }
    return selectedCondition
  }

  generateForecast(weatherCards: WeatherCards.WeatherCard[]) {
    let cards = weatherCards.slice()
    let results = []
    while (this.forecast.length < 3) {
      shuffle(cards)
      results.push(this.forecast.push(cards.pop()))
    }
    return results
  }

  setCosts(sprintNumber: number) {
    return this.stats.fixedCostPerDay += 50 * sprintNumber;
  }

  neutralPrice() {
    var marketForce, neutralPrice;
    marketForce = this.stats.marketing + this.stats.sales + this.stats.design;
    if (marketForce <= 0) {
      marketForce = 1;
    }
    neutralPrice = 1 + marketForce / 100;
    return neutralPrice;
  }

  calculateDemand(weather: WeatherCards.WeatherCard, day: Day) {
    var demand, neutralPrice, ratio;
    demand = this.stats.averageDemand;
    demand *= weather.averageDemand;
    neutralPrice = this.neutralPrice();
    if (!(day.price === neutralPrice) && !(day.price === 0)) {
      ratio = neutralPrice / day.price;
    } else {
      ratio = 10;
    }
    demand *= ratio;
    return demand;
  }

  setCreditLimit() {
    var newLimit, stats;
    stats = this.stats;
    newLimit = stats.cash / 10 + this.getRevenueHistory(7);
    if (newLimit < 1000) {
      newLimit = 1000;
    } else if (newLimit > 50000) {
      newLimit = 50000;
    }
    newLimit = newLimit - (newLimit % 1000);
    newLimit = Math.round(newLimit);
    if (newLimit < 1000) {
      newLimit = 1000;
    } else if (newLimit > 50000) {
      newLimit = 50000;
    }
    return stats.creditLimit = newLimit;
  }

  doesPassFinancialCheck() {
    if (this.stats.cash > 0 - this.stats.creditLimit) {
      return true;
    } else {
      return false;
    }
  }

  predictBusinessValue(numCustomers: number) {
    let estDayRevenue =
      ((this.neutralPrice() - this.stats.variableCostPerDay) * numCustomers)
      - this.stats.fixedCostPerDay
    let yearlyRevenue = estDayRevenue * 365;
    return this.stats.projectedValue = yearlyRevenue;
  }

  getRevenueHistory(numberOfRecords: number) {
    let runningTotal = 0
    if (this.dailyRevenueHistory.length >= numberOfRecords) {
      for(let i = 0; i < numberOfRecords; i++) {
        let recordIndex = this.dailyRevenueHistory.length - (numberOfRecords - i)
        runningTotal += this.dailyRevenueHistory[recordIndex]
      }
    }
    else if(this.dailyRevenueHistory.length === 0) {
      console.log("No entries in Daily Revenue History")
    }
    else {
      for(let entry of this.dailyRevenueHistory) {
        runningTotal += entry
      }
    }
    return runningTotal
  }

}