import { BusinessObject } from '../BusinessObject'
import { Card } from '../cards/job-cards'

export interface Thresholds {
  development: number
  design: number
  marketing: number
  research: number
  sales: number
  fundraising: number
  productivity: number
  cash: number
  equity: number
}

export class EventCard {
  id: string
  name: string
  icon: string
  expiry: number
  description: string
  isRejectable: boolean
  acceptText: string
  rejectText: string
  cost: number
  equity: number
  thresholds: Thresholds

  constructor(name: string, id: string, icon: string) {
    this.name = name
    this.id = id
    this.icon = icon
    this.expiry = -1 //never expires
    this.description = "An event occurred"
    this.isRejectable = true
    this.acceptText = "Accept"
    this.rejectText = "Reject"
    this.cost = 0
    this.equity = 0
    this.thresholds = {
      development: 0,
      design: 0,
      marketing: 0,
      research: 0,
      sales: 0,
      fundraising: 0,
      productivity: 0,
      cash: 0,
      equity: 0
    }
  }

  hasBusinessMetConditions(business: BusinessObject): boolean {
    let thresholdsMet = true
    const thresholds: any = this.thresholds
    const currentStats: any = business.stats
    for(let statName in this.thresholds) {
      let value = thresholds[statName]
      if (value != 0 && value > currentStats[statName]) {
        thresholdsMet = false
      }
    }
    return thresholdsMet
  }

  tick(business: BusinessObject, tasks: Card[]): void {
    if (this.expiry === -1) {
      return
    }
    else {
      this.expiry--
      if (this.expiry <= 0) {
        const index = business.assets.indexOf(this)
        business.assets.splice(index, 1)
        this.onDestroy(business)
      }
    }
  }

  onAccept(business: BusinessObject) {
    business.stats.cash -= this.cost
    business.stats.equity -= this.equity
  }

  onReject(business: BusinessObject) {

  }

  onDestroy(business: BusinessObject) {

  }

}

//marketing cards
export class PRAgentEventCard extends EventCard {
  constructor() {
    super("PR Agent", "mkt", "rss")
    this.description = "A PR Agent has agreed to help work with your team for the next few days"
    this.acceptText = "Great"
    this.rejectText = "Nah"
    this.expiry = 5 //3 days after receipt
    this.thresholds.marketing = 50
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    for (let task of tasks)
      task.marketing = task.marketing * 1.2
    business.stats.averageDemand += 10
    business.stats.potentialMarketSize += 10
  }
}

export class PRAgentEventCard_B extends EventCard {
  constructor() {
    super("PR Agent 2", "mkt", "rss")
    this.description = "A PR Agent has agreed to help work with your team for the next few days"
    this.acceptText = "Great"
    this.rejectText = "Nah"
    this.expiry = 3 //3 days after receipt
    this.thresholds.marketing = 120
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    for (let task of tasks)
      task.marketing = task.marketing * 1.4
    business.stats.averageDemand += 20
    business.stats.potentialMarketSize += 20
  }
}

export class GoneViralCardGood extends EventCard {
  constructor() {
    super("Going Viral?", "mkt", "rss")
    this.description = "A friend has offered to make you an auto-tuned Youtube music video."
    this.acceptText = "Milk it"
    this.rejectText = "Negative"
    this.expiry = 3 //3 days after receipt
    this.thresholds.marketing = 10
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    for (let task of tasks)
      task.marketing *= 2.5
    business.stats.marketing += 3
    business.stats.cash += 10

  }
}

//research cards

export class ProductMarketFitCard extends EventCard {
  constructor() {
    super("Product Market Fit", "res", "graph")
    this.description = "After extensive customer research you have an idea..."
    this.acceptText = "Try it"
    this.rejectText = "Not ready"
    this.expiry = -1
    this.thresholds.research = 20
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.potentialMarketSize *= Math.round((Math.random() * (1.25 - 0.9)) + 0.9)
  }
}

//fundraising cards

export class MoneyFromDadCard extends EventCard {
  constructor() {
    super("$200 From Dad", "fun", "credit-card")
    this.acceptText = "Accept"
    this.rejectText = "Too Proud"
    this.description = "Your Dad doesn't want you to starve. Or eat too much."
    this.expiry = 0
  }

  hasBusinessMetConditions(business: BusinessObject): boolean {
    if (business.stats.cash < -100)
      return true
    return false
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.cash += 200
  }
}

export class MoneyFromDadCard_Generous extends EventCard {
  constructor() {
    super("$1000 From Dad", "fun", "credit-card")
    this.acceptText = "Accept"
    this.rejectText = "Too Proud"
    this.description = "You're worrying your parents. Which does have some benefits?"
    this.expiry = 0
  }

  hasBusinessMetConditions(business: BusinessObject) {
    if (business.stats.cash < -500)
      return true
    return false
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.cash += 1000
  }
}

export class MoneyFromMomCard extends EventCard {
  constructor() {
    super("$250 From Mom", "fun", "credit-card")
    this.acceptText = "Accept"
    this.rejectText = "Too Proud"
    this.description = "Your Mom is offering you lunch. For a week."
    this.expiry = -1
    this.thresholds.cash = 100
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.cash += 250
  }
}

export class MoneyFromMomCard_Generous extends EventCard {
  constructor() {
    super("$750 From Mom", "fun", "credit-card")
    this.acceptText = "Accept"
    this.rejectText = "Too Proud"
    this.description = "Turns out your Mom can still see your account balance. That was an awkward phone call."
    this.expiry = 0
  }

  hasBusinessMetConditions(business: BusinessObject) {
    if (business.stats.cash < -1000)
      return true
    return false
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.cash += 750
  }
}

export class CrowdfundingCampaignCard extends EventCard {
  constructor() {
    super("Kick my Lemons", "fun", "credit-card")
    this.description = "Try a crowdfunding campaign? People say they want your lemonade. Or at least the t-shirt."
    this.acceptText = "Go for it"
    this.rejectText = "Tacky. No"
    this.expiry = 0
    this.thresholds.marketing = 15
    this.thresholds.fundraising = 50
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.cash += Math.round((Math.random() * (15000 - 2500)) + 2500)
    business.stats.marketing += 5
  }
}

export class CrowdfundingCampaignCard_B extends EventCard {
  constructor() {
    super("Lemons-A-Go-Go", "fun", "credit-card")
    this.description = "I think this pitch video is pretty good?"
    this.acceptText = "Go for it"
    this.rejectText = "Tacky. No"
    this.expiry = 5
    this.thresholds.marketing = 7
    this.thresholds.fundraising = 25
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    for (let task of tasks) {
      business.stats.cash += Math.round((Math.random() * (200 - 10)) + 10)
    }
    business.stats.marketing += 2
  }
}

export class SeedInvestmentCard extends EventCard {
  constructor() {
    super("Ignore the Horns", "fun", "credit-card")
    this.description = "A gentleman with a dashing goatee offered $20,000 for 20%. And some fine print."
    this.acceptText = "Thanks!"
    this.rejectText = "No way."
    this.expiry = 0
    this.thresholds.fundraising = 15
    this.thresholds.equity = 20
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.cash += 20000
    business.stats.equity -= 20
  }
}

export class SeedInvestmentCard_B extends EventCard {
  constructor() {
    super("Thirsty Banker", "fun", "credit-card")
    this.description = "An investment banker passed by. He sees an opportunity. $30,000 for 20%."
    this.acceptText = "Great"
    this.rejectText = "Nope"
    this.expiry = 0
    this.thresholds.development = 15
    this.thresholds.equity = 20
    this.equity = 20
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.cash += 30000
  }
}

export class SeedInvestmentCard_C extends EventCard {
  constructor() {
    super("Angel Investor", "fun", "credit-card")
    this.description = "A veteran investor wants in. $30,000 for 20%."
    this.acceptText = "Great"
    this.rejectText = "Nope"
    this.expiry = 0
    this.thresholds.fundraising = 30
    this.equity = 20
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.cash += 30000
  }
}

// sales cards
export class GreatSalesPitchCard extends EventCard {
  constructor() {
    super("Perfect Pitch", "sal", "comment-square")
    this.description = "You've practiced your elevator speech and it's ready."
    this.isRejectable = false
    this.expiry = -1
    this.thresholds.sales = 30
    this.acceptText = "Use it"
    this.rejectText = "Too shy"
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.marketing += 5
    business.stats.sales += 5
  }
}

export class DowntownPermitCard extends EventCard {
  constructor() {
    super("Downtown Vending Permit", "sal", "comment-square")
    this.description = "A permit opened up for a prime corner downtown. Want it? Only $20000...."
    this.isRejectable = false
    this.expiry = -1
    this.thresholds.sales = 60
    this.thresholds.cash = 20000
    this.cost = 20000
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.marketing += 8
    business.stats.sales += 6
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.potentialMarketSize += 8000
    business.stats.fixedCostPerDay += 80
  }
}

export class SuburbanPermitCard extends EventCard {
  constructor() {
    super("Suburban Vending Permit", "sal", "comment-square")
    this.description = "A permit opened up for a spot in a residential neighbourhood. Want it? $10000."
    this.isRejectable = false
    this.expiry = -1
    this.thresholds.sales = 40
    this.thresholds.cash = 10000
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.marketing += 5
    business.stats.sales += 2
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.potentialMarketSize += 4000
    business.stats.fixedCostPerDay += 50
  }
}

export class FranchiseCard extends EventCard {
  constructor() {
    super("Second Cart Life", "sal", "comment-square")
    this.description = "We could open another cart. It would cost about $50000"
    this.isRejectable = false
    this.expiry = -1
    this.thresholds.sales = 40
    this.thresholds.marketing = 40
    this.thresholds.cash = 25000
    this.thresholds.equity = 10
    this.cost = 50000
    this.equity = 10
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.marketing += 10
    business.stats.sales += 4
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.potentialMarketSize += 10000
    business.stats.fixedCostPerDay += 100
  }
}

export class BrandAmbassadorCard extends EventCard {
  constructor() {
    super("Brand Ambassador", "sal", "musical-note")
    this.description = "Rapper 50 Cent's cousin likes our lemonade! She's agreed to promote us for $10,000."
    this.acceptText = "Sign us up!"
    this.rejectText = "Err ... no?"
    this.expiry = 5
    this.thresholds.marketing = 15
    this.thresholds.sales = 25
    this.thresholds.cash = 10000
    this.cost = 10000
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    for (let task of tasks) {
      task.marketing = task.marketing * 2
      task.sales = task.sales * 1.5
    }
    business.stats.marketing += 5
    business.stats.potentialMarketSize *= 1.25
  }
}

export class BrandAmbassadorCard_B extends EventCard {
  constructor() {
    super("Brand Ambassador 2", "sal", "musical-note")
    this.description = "For 10%, Ice-T's manager's favourite dog groomer will do some promotion for us!"
    this.acceptText = "Do it!"
    this.rejectText = "Nope"
    this.expiry = 10
    this.thresholds.marketing = 50
    this.thresholds.sales = 25
    this.thresholds.equity = 10
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    for (let task of tasks) {
      task.marketing = task.marketing * 2
      task.sales = task.sales * 1.5
    }
    business.stats.marketing += 5
    business.stats.potentialMarketSize *= 1.1
    business.stats.equity -= 1
  }
}

export class CrossPromotionCard extends EventCard {
  constructor() {
    super("Cross Promotion", "sal", "musical-note")
    this.description = "Know what goes with lemonade? Salmon! They want to co-market with us."
    this.acceptText = "Yum"
    this.rejectText = "Gross"
    this.expiry = 3
    this.thresholds.marketing = 8
    this.thresholds.sales = 7
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    for (let task of tasks) {
      task.marketing = task.marketing * 2
      task.sales = task.sales * 2
    }
    business.stats.marketing += 7
    business.stats.potentialMarketSize *= 1.1
    business.stats.equity -= 5
  }
}

//development cards

export class CaffinatedLemonsCard extends EventCard {
  constructor() {
    super("Caffinated Lemons", "dev", "beaker")
    this.description = "You can now infuse your lemons with caffeine. Do it?"
    this.acceptText = "Oh yeah!"
    this.rejectText = "Nope"
    this.expiry = -1
    this.thresholds.development = 80
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.variableCostPerDay += 0.10
    business.stats.potentialMarketSize += 20000
  }
}

export class LemonadeEyedropsCard extends EventCard {
  constructor() {
    super("Lemonade Eyedrops", "dev", "eyedropper")
    this.description = "You haven't tried them yet, but maybe they'll sell."
    this.acceptText = "Do it"
    this.rejectText = "Uh..."
    this.expiry = -1
    this.thresholds.development = 30
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.variableCostPerDay += 0.10
    business.stats.potentialMarketSize += 5000
  }
}

export class IntravenousLemonadeCard extends EventCard {
  constructor() {
    super("Intravenous Lemonade", "dev", "eyedropper")
    this.description = "Now your customers never have to stop drinking lemonade!"
    this.acceptText = "Okay"
    this.rejectText = "No"
    this.expiry = -1
    this.thresholds.development = 60
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.variableCostPerDay += 0.10
    business.stats.potentialMarketSize += 10000
  }
}

export class BloodLemonsCard extends EventCard {
  constructor() {
    super("Blood Lemons", "res", "comment-square")
    this.description = "You've sourced some cheap lemons from abroad and they taste fine. Use them?"
    this.acceptText = "Oh yeah!"
    this.rejectText = "Nope"
    this.expiry = -1
    this.thresholds.research = 10
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.marketing -= 1
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.variableCostPerDay -= 0.15
  }
}

export class GoneViralBadCard extends EventCard {
  constructor() {
    super("Gone Viral", "dev", "bug")
    this.description = "Like actually viral. We need a product recall."
    this.acceptText = "Meh"
    this.rejectText = "Do it"
    this.expiry = 0
    this.thresholds.development = 5
  }

  hasBusinessMetConditions(business: BusinessObject) {
    let thresholdsMet = true
    let thresholds: any = this.thresholds
    let businessStats: any = business.stats
    for (let stat in thresholds) {
      let value = thresholds[stat]
      if (value != 0 && businessStats[stat] > value)
        thresholdsMet = false
    }
    return thresholdsMet
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.marketing -= 10
    business.stats.sales -= 10
    business.stats.potentialMarketSize *= 0.75
  }
}

export class SlickPackagingCard extends EventCard {
  constructor() {
    super("Slick Packaging", "des", "comment-square")
    this.description = "You've been polishing your Photoshop skills and have a new packaging concept. Use it?"
    this.acceptText = "Sure"
    this.rejectText = "Meh"
    this.expiry = -1
    this.thresholds.design = 18
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.averageDemand += 15
    business.stats.marketing += 1
  }
}

export class SuperSlickPackagingCard extends EventCard {
  constructor() {
    super("Super Slick Packaging", "des", "aperture")
    this.description = "Don't you think this looks cooler?"
    this.acceptText = "Sure"
    this.rejectText = "Meh"
    this.expiry = -1
    this.thresholds.design = 40
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.averageDemand += 100
    business.stats.marketing += 2
    business.stats.sales += 1
  }
}

export class DesignAwardCard extends EventCard {
  constructor() {
    super("Design Award", "des", "badge")
    this.description = "So, we won a design award. But we need to pay to accept it. Worth $2500?"
    this.acceptText = "Sure"
    this.rejectText = "No way"
    this.expiry = -1
    this.thresholds.design = 60
    this.cost = 2500
  }

  tick(business: BusinessObject, tasks: Card[]) {
    super.tick(business, tasks)
    business.stats.averageDemand += 60
    business.stats.marketing += 5
  }

  onAccept(business: BusinessObject) {
    super.onAccept(business)
    business.stats.potentialMarketSize += 4000
  }
}
