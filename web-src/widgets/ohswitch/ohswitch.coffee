class Dashing.Ohswitch extends Dashing.ClickableWidget
  constructor: ->
    super
    @queryState()

  @accessor 'state',
    get: -> @_state ? 'OFF'
    set: (key, value) -> @_state = value

  @accessor 'icon',
    get: -> if @['icon'] then @['icon'] else
      if @get('state') == 'ON' then @get('iconon') else @get('iconoff')
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconon',
    get: -> @['iconon'] ? 'circle'
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconoff',
    get: -> @['iconoff'] ? 'circle-thin'
    set: Batman.Property.defaultAccessor.set

  @accessor 'icon-style', ->
    if @get('state') == 'ON' then 'switch-icon-on' else 'switch-icon-off'

  toggleState: ->
    newState = if @get('state') == 'ON' then 'OFF' else 'ON'
    @set 'state', newState
    return newState

  queryState: ->
    Ohbridge.queryState @get('device'), (data) =>
      @set 'state', data
      @onData(data)

  postState: ->
    newState = @toggleState()
    Ohbridge.setState @get('device'), newState

  ready: ->

  onClick: (event) ->
    @postState()

  onData: (data) ->
    if `data == parseInt(data, 10)`
      @set 'state', if data > 0 then "ON" else "OFF"
