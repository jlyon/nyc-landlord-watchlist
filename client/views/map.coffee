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
    console.log "results data"
    
    Meteor.call "numBuildings", Session.get "activeBorough", Session.get "pageStart", (error, result) ->
      console.log(result)
      Session.set("numBuildings", result)

    data = Buildings.find().fetch()

    if isReady()
      console.log "res"
      console.log data.length
      window.markersAdded = true
      updateMakers data
      return data
)

Template.results.events(
  'click a': (e) ->
    e.preventDefault()
    console.log "results click"
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
    console.log this.value 
    console.log Session.get "pageStart"
    if this.value is Session.get "pageStart" then "active" else ""
  pages: ->
    console.log "pager update"
    pageStart = Session.get "pageStart"
    numBuildings = Session.get "numBuildings"
    console.log numBuildings
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
    console.log items
    return items
)

Template.pager.events(
  'click a': (e) ->
    e.preventDefault()
    Session.set 'pageStart', this.value
    buildingSubscribe Session.get("activeBorough"), this.value
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

    window.loaded = true

  #markers.push(marker);
  ###.bindPopup(Meteor.render(Template.popup),{
    closeButton: true
  }).on('popupopen', function(e) {
    jQuery('#building-list .item').removeClass('active');
    jQuery('#building-list #building-' + this.options.i).addClass('active');
    updateData(this.options.name, this.options.address);
  }).on('popupclose', function(e) {
    jQuery('#building-list .item').removeClass('active');
  }).on('mouseover', function(e) {
    var size = this.options.size + 5;
    this.setOpacity(1);
    this.setIcon(L.icon({
      iconUrl: 'circle.png',
      iconSize:   [size, size],
      iconAnchor:   [size/2, size/2],
      popupAnchor:  [0, -(size/2 + 5)]
    }));
  }).on('mouseout', function(m) {
    var size = this.options.size;
    this.setOpacity(.8);
    this.setIcon(L.icon({
      iconUrl: 'circle.png',
      iconSize:   [size, size],
      iconAnchor:   [size/2, size/2],
      popupAnchor:  [0, -(size/2 + 5)]
    }));
  }).addTo(map);
  

  // Add data to the
  if (j < 20) {
    var stripe = (Math.round(j/2) == j/2) ? 'even' : 'odd';
    $('<div class="item addressWrapper '+ stripe +'" id="building-'+ j +'"><div class="ranking pull-left dataValue highlighted">'+entry[5]+'</div><strong>'+entry[0]+'</strong><br/>'+entry[3]+'<br/>'+entry[4]).appendTo('#building-list');
    jQuery('#building-list .item').bind('click', function() {
      currentMarker = parseInt(jQuery(this).attr('id').replace('building-', ''));
      showMarker();
      stopCycle();
      return false;
    })
  }
  j++;
  ###

@clearMarkers = ->
  window.markerLayer.clearLayers() if window.markerLayer?

@updateMakers = (data) ->
  borough = Session.get "activeBorough"
  console.log "update"
  console.log data
  $results = $("#results")
  clearMarkers()

  _.each data, (item, index)->

    # add fields to item
    item.size = Math.round(item.num/20) + 5;
    item.rank = index # @todo
    item.latlng = 

    # add markers
    marker = L.marker(itemLatlng(item),
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
    ).addTo window.markerLayer

    $("body").addClass "left-sidebar-active"


@openPopup = (item) ->
  Session.set('activeBuilding', this._id)
  item.location = encodeURIComponent(item.street_address + " " + item.borough + ", NY " + item.zip)
  popup = L.popup()
    .setLatLng(itemLatlng(item))
    .setContent(Template.popup(item))
    .openOn window.map


@itemLatlng = (item) ->
  return new L.LatLng parseFloat(item.lng), parseFloat(item.lat)