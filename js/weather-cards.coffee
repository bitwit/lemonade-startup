class WeatherCard
  constructor: (@icon) ->
    #mulitpliers
    @description = "Weather description"
    @fixedCostPerDay = 1.0
    @variableCostPerDay = 1.0
    @averageDemand = 1.0
    @temperatureHigh = 20
    @temperatureLow = 17
    @temperature = null

  calculateTemperature: ->
    @temperature = Math.round((Math.random() * (@temperatureHigh - @temperatureLow)) + @temperatureLow)

class HeatWaveWeatherCard extends WeatherCard
  constructor: ->
    super "fire"
    @averageDemand = 2.0
    @description = "Blisteringly hot out today."
    @temperatureHigh = 38
    @temperatureLow = 30

class GoodWeatherCard extends WeatherCard
  constructor: ->
    super "sun"
    @averageDemand = 1.2
    @description = "It's a beautiful day outside"
    @temperatureHigh = 29
    @temperatureLow = 24

class AverageWeatherCard extends WeatherCard
  constructor: ->
    super "cloud"
    @description = "Fair weather outside today"
    @temperatureHigh = 23
    @temperatureLow = 20

class RainyWeatherCard extends WeatherCard
  constructor: ->
    super "rain"
    @averageDemand = 0.5
    @description = "It's very rainy out today"
    @temperatureHigh = 26
    @temperatureLow = 17

class ColdWeatherCard extends WeatherCard
  constructor: ->
    super "cloudy"
    @averageDemand = 0.5
    @description = "It's freezing outside"
    @temperatureHigh = 17
    @temperatureLow = 12

