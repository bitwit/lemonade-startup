import { BusinessObject } from '../BusinessObject'

export class Card {
  id: string
  name: string
  icon: string
  development: number
  design: number
  marketing: number
  research: number
  sales: number
  fundraising: number
  potentialMarketSize: number
  productivity: number
  fixedCostPerDay: number
  variableCostPerDay: number
  averageDemand: number

  constructor(name: string, id: string, icon: string) {
    this.name = name 
    this.id = id
    this.icon = icon
    this.development = 0
    this.design = 0
    this.marketing = 0
    this.research = 0
    this.sales = 0
    this.fundraising = 0
    this.potentialMarketSize = 0
    this.productivity = 0
    this.fixedCostPerDay = 0
    this.variableCostPerDay = 0
    this.averageDemand = 0
  }

  merge (business: BusinessObject) {
    let stats = business.stats
    stats.development += this.development
    stats.design += this.design
    stats.marketing += this.marketing
    stats.research += this.research
    stats.sales += this.sales
    stats.fundraising += this.fundraising
    stats.potentialMarketSize += this.potentialMarketSize
    stats.productivity += this.productivity
    stats.fixedCostPerDay += this.fixedCostPerDay
    stats.variableCostPerDay += this.variableCostPerDay
    stats.averageDemand += this.averageDemand
  }
}

export class MarketingCard extends Card {
  constructor() {
    super("Marketing", "mkt", "target")
    this.marketing = 2
    this.potentialMarketSize = 20
  }
}

export class DevelopmentCard extends Card {
  constructor() {
    super("Development", "dev", "wrench")
    this.development = 2
    this.variableCostPerDay = -0.02
  }
}

export class ResearchCard extends Card {
  constructor() {
    super("Research", "res", "lightbulb")
    this.research = 2
    this.fixedCostPerDay = -2
  }
}

export class DesignCard extends Card {
  constructor() {
    super("Design", "des", "brush")
    this.design = 2
    this.averageDemand = 5
    this.variableCostPerDay = 0.01
  }
}

export class SalesCard extends Card {
  constructor() {
    super("Sales", "sal", "graph")
    this.sales = 2
    this.averageDemand = 20
  }
}

export class FundraisingCard extends Card {
  constructor() {
    super("Fundraising", "fun", "dollar")
    this.fundraising = 2
  }
}