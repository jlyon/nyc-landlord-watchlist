Meteor.Router.add(
  '/': ->
    $("body").removeClass "left-sidebar-active"
    $("body").removeClass "right-sidebar-active"
    Session.set "title", "Landlords"
    clearMap()
    "landlords"

  '/buildings': ->
      Session.set "title", "The worst buildings in NYC"
      console.log "buildings"
      buildingsSubscribe()
      $("body").addClass "left-sidebar-active"
      $("body").removeClass "right-sidebar-active"
      clearMap()
      "results"

  '/buildings/:borough': (borough) ->
    borough = borough.replace('-', ' ')
    Session.set "title", "The worst buildings in " + (if borough is "Bronx" then "the " + borough else borough)
    Session.set "activeBorough", borough
    buildingsSubscribe borough, 0
    $("body").addClass "left-sidebar-active"
    $("body").removeClass "right-sidebar-active"
    clearMap()
    "results"

)
