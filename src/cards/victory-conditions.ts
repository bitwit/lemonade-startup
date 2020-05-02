import { BusinessObject } from "../BusinessObject"

export class VictoryCondition {
  id: string
  name: string
  icon: string

  description: string = "An event occurred"
  priority: number = 0

  constructor(name: string, id: string, icon: string) {
    this.name = name
    this.id = id
    this.icon = icon
  }

  hasMetBusinessConditions(business: BusinessObject) {
    return false
  }
}

export class BootstrapEnding extends VictoryCondition {
  constructor() {
    super("Bootstrapped","sal","dollar")
    this.description = "Squeezing lemons by hand? Nope. Now, you just roll over them with a Ferrari. I guess that means you made it?"
    this.priority = 10
  }
  hasBusinessMetConditions (business: BusinessObject) {
    let conditionsMet = true
    if(business.stats.cash < 100000)
      conditionsMet = false
    if(business.stats.equity < 100)
      conditionsMet = false
    return conditionsMet
  }
}
  
export class ALittleBetterEnding extends VictoryCondition {
  constructor() {
    super("Still in Business", "sal", "thumb-up")
    this.description = "I can pay myself now!"
    this.priority = 1
  }

  hasBusinessMetConditions(business: BusinessObject) {
    let conditionsMet = true
    if(business.stats.cash < 25000)
      conditionsMet = false
    if(business.stats.equity <= 0)
      conditionsMet = false
    return conditionsMet
  }
}
  
export class StagnantEnding extends VictoryCondition {
  constructor() {
    super("Still Here","sal","dollar")
    this.description = "Yesterday, I squeezed lemons, today I am squeezing lemons, and tomorrow I will squeeze lemons. Lemon, lemon, something, lemon."
    this.priority = 1
  }

  hasBusinessMetConditions(business: BusinessObject) {
    let conditionsMet = true
    if(business.stats.cash >= 25000)
      conditionsMet = false
    if(business.stats.equity <= 0)
      conditionsMet = false
    return conditionsMet
  }
}

export class AcquiredEnding extends VictoryCondition {
  constructor() {
    super("JuiceBook is Calling", "sal", "thumb-up")
    this.description = "Lemons? Have fun with that. I'm out. See you in Paris."
    this.priority = 9
  }

  hasBusinessMetConditions(business: BusinessObject) {
    let conditionsMet = true
    if(business.stats.projectedValue < 5000000)
      conditionsMet = false
    if(business.stats.fundraising < 50)
      conditionsMet = false
    if(business.stats.development < 20)
      conditionsMet = false
    if(business.stats.marketing < 30)
      conditionsMet = false
    return conditionsMet
  }
}

export class SoftHostileTakeoverEnding extends VictoryCondition {
  constructor() {
    super("'Voluntary' Resignation", "sal", "thumb-up")
    this.description = "The board pushed you out. But you got paid. Lemons are so passé anyway. Time to disrupt the world of Agave."
    this.priority = 7
  }

  hasBusinessMetConditions(business: BusinessObject) {
    let conditionsMet = true
    if(business.stats.equity > 50)
      conditionsMet = false
    return conditionsMet
  }
}

export class HostileTakeoverEnding extends VictoryCondition {
  constructor() {
    super("Hostile Takeover", "sal", "thumb-down")
    this.description = "You barely own the business anymore and you weren't doing the business any favours"
    this.priority = 8
  }

  hasBusinessMetConditions(business: BusinessObject) {
    let conditionsMet = true
    if(business.stats.cash > 15000)
      conditionsMet = false
    if(business.stats.equity > 50)
      conditionsMet = false
    return conditionsMet
  }
}

export class BankruptEnding extends VictoryCondition {
  constructor() {
    super("Bankrupt", "sal", "thumb-down")
    this.description = "The lemonade stand? Oh, no, I work at Starbucks now."
    this.priority = 1
  }

  hasBusinessMetConditions(business: BusinessObject) {
    let conditionsMet = true
    if(business.stats.cash > 0)
      conditionsMet = false
    return conditionsMet
  }
}
