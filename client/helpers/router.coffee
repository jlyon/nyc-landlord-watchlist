Meteor.Router.add(
  '/': ->
    $("body").removeClass "left-sidebar-active"
    Session.set "title", "Landlords"
    clearMarkers()
    "landlords"

  '/buildings': ->
      Session.set "title", "The worst buildings in NYC"
      console.log "buildings"
      buildingSubscribe()
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
