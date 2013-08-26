###
Template.map.helpers(
  collectionsLoaded: ->
    isReady
)
###
Session.set "pageStart", 0

Template.results.helpers(
  title: ->
    Session.get "title"
  data: ->
    borough = Session.get("activeBorough")
    pageStart = Session.get("pageStart")
    
    Meteor.call "numBuildings", borough, pageStart, (error, result) ->
      Session.set("numBuildings", result)

    data = Buildings.find().fetch()

    if isReady()
      window.markersAdded = true
      updateMakers data
      return data
)

Template.results.events(
  'click .item a': (e) ->
    e.preventDefault()
    Session.set('activeBorough', this._id)
)


Template.pager.helpers(
  total: ->
    return Session.get "numBuildings"
  start: ->
    return Session.get("pageStart") + 1
  end: ->
    num = Session.get "numBuildings"
    pageStart = Session.get "pageStart"
    if num < pageStart + pageSize then return num else return pageStart + pageSize
  active: ->
    if this.value is Session.get "pageStart" then "active" else ""
  pages: ->
    pageStart = Session.get "pageStart"
    numBuildings = Session.get "numBuildings"
    if pageStart > pageSize*2
      min = pageStart - pageSize*2
      endPages = 2
    else
      min = 0
      endPages = 4 - pageStart/pageSize
    max = (if numBuildings < pageStart + pageSize*endPages then numBuildings else pageStart + pageSize*endPages)
    items = []
    items.push(label: "&laquo;", value: pageStart-pageSize) if pageStart > 0
    for i in [min..max] by pageSize
      items.push
        label: i/pageSize + 1
        value: i
        class: if pageStart is i then "active" else ""
    items.push(label: "&raquo;", value: pageStart+pageSize) if pageStart + pageSize < numBuildings
    return items
)

Template.pager.events(
  'click a': (e) ->
    e.preventDefault()
    Session.set 'pageStart', this.value
    buildingsSubscribe Session.get("activeBorough"), this.value
)


Template.map.rendered = ->
  #if not $("body").hasClass "left-sidebar-active"
  #if window.map is `undefined`
  # create a map in the map div, set the view to a given place and zoom
  if window.loaded isnt true
    window.map = L.map 'map', 
      doubleClickZoom: false
    .setView([40.78847003749051, -73.9185905456543], 12)

    # add a CloudMade tile layer with style #997 - use your own cloudmade api key
    L.tileLayer "http://a.tiles.mapbox.com/v3/albatrossdigital.map-yaq188c8/{z}/{x}/{y}.png", 
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>'
    .addTo(window.map)
    
    window.markerLayer = new L.FeatureGroup()
    window.markerLayer.addTo window.map

    window.popupLayer = new L.FeatureGroup()
    window.popupLayer.addTo window.map

    window.loaded = true
    console.log "RENDERED"
    window.changed = true


@clearMarkers = ->
  window.markerLayer.clearLayers() if window.markerLayer?
  window.popupLayer.clearLayers() if window.popupLayer?


@updateMakers = (data) ->
  console.log "update"
  borough = Session.get "activeBorough"
  $results = $("#results")
  clearMarkers()

  _.each data, (item, index)->

    # add fields to item
    item.size = Math.round(item.num/20) + 5;
    item.rank = index + Session.get "pageStart" # @todo
    latlng = itemLatlng(item)

    # add markers
    if latlng?
      marker = L.marker(latlng,
        icon: new L.divIcon(
          className: 'circle-marker'
          iconSize: [item.size, item.size]
        )
        title: item.org+', '+item.num+' outstanding requests'
        name: item.org
        index: index
        opacity: .7
        size: item.size
        _id: item._id
      ).on("click", (e) ->
        item = Buildings.findOne({_id: e.target.options._id})
        openPopup item
        console.log 'clicked'
        scroll $('#results'), $('#building-'+item._id)
      ).addTo window.markerLayer

      $("body").addClass "left-sidebar-active"
  
  resizeMap()

  if window.changed

    # open the first popup (after a slight delay to allow item to be loaded in DOM)
    window.setTimeout ->
      openPopup data[0]
      #Session.set "changed", false
    , 50
    window.changed = false


@openPopup = (item) ->
  Session.set('activeBuilding', item._id)
  item.location = encodeURIComponent(item.street_address + " " + item.borough + ", NY " + item.zip)
  item.change = item.num - item.previous
  if item.change > 0 then item.changeDirection = "up" else item.changeDirection = "down"
  #item.change = Math.abs item.change
  popup = L.popup()
    .setLatLng(itemLatlng(item))
    .setContent(Template.popup(item))
    .openOn window.map


@setCenter = (item) ->
  window.map.panTo itemLatlng(item)

@itemLatlng = (item) ->
  if item? and item.lat? and item.lng?
    return new L.LatLng parseFloat(item.lng), parseFloat(item.lat)

@resizeMap = ->
  window.setTimeout ->
    window.map.invalidateSize animate: true
  , 500

@clearMap = ->
  clearMarkers()
  resizeMap()

@scroll = (parent, element) ->
  if window.responsive is "mobile"
    parent = "body"
    top = if element is 0 then 0 else $(element).offset().top - 75
  else
    top = if element is 0 then 0 else $(parent).scrollTop() + $(element).offset().top - $(parent).offset().top
  $(parent).animate({ scrollTop: top }, { duration: 'slow', easing: 'swing'})