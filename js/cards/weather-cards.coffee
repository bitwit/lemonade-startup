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
    @description = "Heat Wave Warning"
    @temperatureHigh = 38
    @temperatureLow = 30

class GoodWeatherCard extends WeatherCard
  constructor: ->
    super "sun"
    @averageDemand = 1.2
    @description = "Sunny with clouds"
    @temperatureHigh = 29
    @temperatureLow = 24

class AverageWeatherCard extends WeatherCard
  constructor: ->
    super "cloud"
    @description = "Partially cloudy"
    @temperatureHigh = 23
    @temperatureLow = 20

class RainyWeatherCard extends WeatherCard
  constructor: ->
    super "rain"
    @averageDemand = 0.5
    @description = "Scattered showers"
    @temperatureHigh = 26
    @temperatureLow = 17

class ColdWeatherCard extends WeatherCard
  constructor: ->
    super "cloudy"
    @averageDemand = 0.5
    @description = "Mostly cloudy"
    @temperatureHigh = 17
    @temperatureLow = 12

