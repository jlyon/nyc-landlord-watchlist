Meteor.Router.add(
  '/': ->
    $("body").removeClass "left-sidebar-active"
    clearMarkers()
    "landlords"

  '/buildings': ->
      Session.set "title", "The worst buildings in NYC"
      console.log "buildings"
      $("body").addClass "left-sidebar-active"
      "results"

  '/buildings/:borough': (borough) ->
    borough = borough.replace('-', ' ')
    Session.set "title", "The worst buildings in " + (if borough is "Bronx" then "the " + borough else borough)
    Session.set "activeBorough", borough
    buildingSubscribe borough, 0
    $("body").addClass "left-sidebar-active"
    "results"
)
