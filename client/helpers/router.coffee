Meteor.Router.add(
  '/': ->
    $("body").removeClass "left-sidebar-active"
    $("body").removeClass "right-sidebar-active"
    Session.set "title", "Landlords"
    clearMap()
    "landlords"

  '/landlords/:landlord': (landlord) ->
    Session.set "title", "The worst buildings in NYC"
    buildingsSubscribe undefined, 0, landlord
    enableMap()
    Session.set "activeLandlord", landlord
    Session.set "activeBorough", undefined

  '/buildings': ->
    Session.set "title", "The worst buildings in NYC"
    buildingsSubscribe()
    enableMap()
    

  '/buildings/:borough': (borough) ->
    borough = borough.replace('-', ' ')
    Session.set "title", "The worst buildings in " + (if borough is "Bronx" then "the " + borough else borough)
    Session.set "activeBorough", borough
    buildingsSubscribe borough, 0
    enableMap()
)


@enableMap = ->
  $("body").addClass "left-sidebar-active"
  $("body").removeClass "right-sidebar-active"
  clearMap()
  Session.set "pageStart", 0
  window.changed = true
  "results"