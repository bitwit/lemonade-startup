import * as JobCards from './cards/job-cards'
import { EventCard } from './cards/event-cards'
import { BusinessObject } from './BusinessObject'
import { VictoryCondition } from './cards/victory-conditions'
import { Day } from './classes/Day'

export class AppState {
  sprintDays: Day[] = [
    new Day("1", "Monday"),
    new Day("2", "Tuesday"),
    new Day("3", "Wednesday"),
    new Day("4", "Thursday"),
    new Day("5", "Friday"),
    new Day("6", "Saturday"),
    new Day("7", "Sunday"),
    new Day("8", "Monday"),
    new Day("9", "Tuesday"),
    new Day("10", "Wednesday"),
    new Day("11", "Thursday"),
    new Day("12", "Friday"),
    new Day("13", "Saturday"),
    new Day("14", "Sunday")
  ]
  tasks: JobCards.Card[] = [
    new JobCards.DevelopmentCard(), 
    new JobCards.ResearchCard(), 
    new JobCards.MarketingCard(), 
    new JobCards.DesignCard(), 
    new JobCards.SalesCard(), 
    new JobCards.FundraisingCard()
  ]

  prices = [0, 0.5, 1, 1.5, 2, 3, 4, 5, 7, 10]
  currentView = 'intro'
  price = 3
  sprint = 1
  maxSprints = 1
  currentDay = -1
  progress = 0
  hasStarted = false
  tickSpeed = 30
  isPaused = false
  selectedTaskIndex = 0
  countdownProgress = 0
  announcements: EventCard[] = []
  businessObject = new BusinessObject()
  ending: VictoryCondition | null = null
}