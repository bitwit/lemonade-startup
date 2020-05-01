export class WeatherCard {
  icon: string
  description: string
  fixedCostPerDay: number
  variableCostPerDay: number
  averageDemand: number
  temperatureHigh: number
  temperatureLow: number
  temperature: number | null

  constructor (icon: string) {
    //mulitpliers
    this.icon = icon
    this.description = "Weather description"
    this.fixedCostPerDay = 1.0
    this.variableCostPerDay = 1.0
    this.averageDemand = 1.0
    this.temperatureHigh = 2
    this.temperatureLow = 17
    this.temperature = null
  }

  calculateTemperature() {
    this.temperature = 
      Math.round((Math.random() 
      * (this.temperatureHigh - this.temperatureLow))
      + this.temperatureLow)
  }
}
    
export class HeatWaveWeatherCard extends WeatherCard {
  constructor() {
    super("fire")
    this.averageDemand = 2.0
    this.description = "Heat Wave Warning"
    this.temperatureHigh = 38
    this.temperatureLow = 30
  }
}

export class GoodWeatherCard extends WeatherCard {
  constructor() {
    super("sun")
    this.averageDemand = 1.2
    this.description = "Sunny with clouds"
    this.temperatureHigh = 29
    this.temperatureLow = 24
  }
}

export class AverageWeatherCard extends WeatherCard {
  constructor() {
    super("cloud")
    this.description = "Partially cloudy"
    this.temperatureHigh = 23
    this.temperatureLow = 20
  }
}

export class RainyWeatherCard extends WeatherCard {
  constructor() {
    super("rain")
    this.averageDemand = 0.5
    this.description = "Scattered showers"
    this.temperatureHigh = 26
    this.temperatureLow = 17
  }
}

export class ColdWeatherCard extends WeatherCard {
  constructor() {
    super("cloudy")
    this.averageDemand = 0.5
    this.description = "Mostly cloudy"
    this.temperatureHigh = 17
    this.temperatureLow = 12
  }
}
