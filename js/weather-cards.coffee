class WeatherCard
  constructor: ->
    #mulitpliers
    @description = "Weather description"
    @fixedCostPerDay = 1.0
    @variableCostPerDay = 1.0
    @averageDemand = 1.0



class HeatWaveWeatherCard extends WeatherCard
  constructor: ->
    super()
    @averageDemand = 2.0
    @description = "Blisteringly hot out today."

class GoodWeatherCard extends WeatherCard
  constructor: ->
    super()
    @averageDemand = 1.2
    @description = "It's a beautiful day outside"

class AverageWeatherCard extends WeatherCard
  constructor: ->
    super()
    @description = "Fair weather outside today"

class RainyWeatherCard extends WeatherCard
  constructor: ->
    super()
    @averageDemand = 0.5
    @description = "It's very rainy out today"

class ColdWeatherCard extends WeatherCard
  constructor: ->
    super()
    @averageDemand = 0.5
    @description = "It's freezing outside"

