
Template.map.helpers(
  collectionsLoaded: ->
    isReady
)

Template.map.events(
  'click a': (e) ->
    alert('adsf')
    Session.set('activeBorough', this._id)
)

Template.map.rendered = ->
  console.log isReady()
  if isReady()

    # create a map in the map div, set the view to a given place and zoom
    @map = L.map 'map', 
      doubleClickZoom: false
    .setView([40.78847003749051, -73.9185905456543], 12)

    # add a CloudMade tile layer with style #997 - use your own cloudmade api key
    L.tileLayer "http://a.tiles.mapbox.com/v3/albatrossdigital.map-yaq188c8/{z}/{x}/{y}.png", 
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>'
    .addTo(@map)

    markerLayer = new L.FeatureGroup()
    markerLayer.addTo @map
    $results = $("#results")


    # stop here
    data = Buildings.find().fetch()
    _.each data, (item, index)->
      size = Math.round(item.num/20) + 5;
      item.rank = index
      item.location = encodeURIComponent(item.street_address + " " + item.borough + ", NY " + item.zip)

      latlon = new L.LatLng parseFloat(item.lng), parseFloat(item.lat)
      marker = L.marker(latlon,
        icon: new L.divIcon(
          className: 'circle-marker'
          iconSize: [size, size]
        )
        title: item.org+', '+item.num+' outstanding requests'
        name: item.org
        index: index
        opacity: .7
        size: size
      ).bindPopup(Template.popup(item),
        closeButton: true
      ).addTo markerLayer
      $(Template.buildingListItem(item)).appendTo($results)


    $("body").addClass "left-sidebar-active"
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