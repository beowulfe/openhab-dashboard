class Dashing.Ohweather extends Dashing.Widget

  @group: "weather"

  @mapping:  {
    "now_temp": "Weather_Temperature",
    "currentConditions": "Weather_Conditions",
    "weather_code": "Weather_Code",
    "temp_high": "Weather_Temp_Max_0",
    "temp_low": "Weather_Temp_Min_0",
    "humidity": "Weather_Humidity",
    "pressure": "Weather_Pressure",
    "tomorrow_temp_high": "Weather_Temp_Max_1",
    "tomorrow_temp_low": "Weather_Temp_Min_1",
    "tomorrow_weather_code": "Weather_Code_1",
    "precip": "Weather_Precipitation",
    "tomorrow_precip": "Weather_Precipitation_1",
    "wind_speed": "Weather_Wind_Speed",
    "wind_dir": "Weather_Wind_Direction",
    "wind_speed_gust": "Weather_Wind_Gust"
  };

  constructor: ->
    super
    @_icons =
      chanceflurries: '&#xe036',
      chancerain: '&#xe009',
      chancesleet: '&#xe003',
      chancesnow: '&#xe036',
      chancetstorms: '&#xe025',
      clear: '&#xe028',
      cloudy: '&#xe000',
      flurries: '&#xe036',
      fog: '&#xe01b',
      hazy: '&#xe01b',
      mostlycloudy: '&#xe001',
      mostlysunny: '&#xe001',
      partlycloudy: '&#xe001',
      partlysunny: '&#xe001',
      sleet: '&#xe003',
      rain: '&#xe009',
      snow: '&#xe036',
      sunny: '&#xe028',
      tstorms: '&#xe025'
    @reverseMap = {}
    for own key, value of Dashing.Ohweather.mapping
      @reverseMap[value] = key
      ((prop) => Ohbridge.subscribe(value, (data) => @set prop, data))(key)
    @queryState()

  @accessor 'climacon', ->
    new Batman.TerminalAccessible (attr) =>
      @_icons[attr]

  @accessor 'now_temp',
    get: -> if @_temp then Math.floor(@_temp) else 0
    set: (key, value) -> @_temp = value

  @accessor 'icon', ->
    if @get('weather_code')?
      @get('weather_code').replace(/\-/g, "").replace(/day/g, "")

  @accessor 'tomorrow_icon', ->
    if @get('tomorrow_weather_code')?
      @get('tomorrow_weather_code').replace(/\-/g, "").replace(/day/g, "")

  queryState: ->
    Ohbridge.queryGroup Dashing.Ohweather.group, (data) =>
      for member in data.members
        if @reverseMap[member.name]?
          @set @reverseMap[member.name], member.state

  ready: ->

  onData: (data) ->
