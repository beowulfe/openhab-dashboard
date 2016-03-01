class Dashing.Ohheating extends Dashing.Widget
  constructor: ->
    super
    @queryState()
    # We don't need to subscribe to 'device' because it's handled by ohbridge
    Ohbridge.subscribe(@get('devicetarget'), (data) => @set 'target', data)

  @accessor 'state',
    get: -> @_state ? "Unknown"
    set: (key, value) ->
      @_state = value

  #    jsonInner = JSON.parse @get('state')
  #     @set 'temperature', jsonInner.temperature
  #     @set 'target', jsonInner.target

  @accessor 'temperature',
    get: -> if @_temperature then parseFloat(@_temperature).toFixed(1) else 0
    set: (key, value) ->
      @_temperature = value

  @accessor 'target',
    get: -> if @_target then parseFloat(@_target).toFixed(1) else 0
    set: (key, value) ->
      @_target = value

  @accessor 'target-style', ->
    if @get('temperature') == @get('target')
      console.log "style: steady"
      'heating-steady'
    else if @get('temperature') < @get('target')
      console.log "style: on"
      'heating-on'
    else
      console.log "style: off"
      'heating-off'

  queryState: ->
    Ohbridge.queryState @get('device'), (data) => @set 'temperature', data
    Ohbridge.queryState @get('devicetarget'), (data) => @set 'target', data

  ready: ->

  onData: (data) ->
    @set 'temperature', data
