Meteor.Router.add(
  '/': ->
    $("body").removeClass "left-sidebar-active"
    $("body").removeClass "right-sidebar-active"
    Session.set "title", "Landlords"
    console.log 'router: front'
    clearMap()
    "landlordsPage"

  '/landlords/:landlord': (landlord) ->
    Session.set "title", "The worst buildings in NYC"
    Session.set "activeLandlord", landlord
    #Session.set "activeBorough", "all"
    console.log 'router: landlord'
    enableMap(true)

  '/buildings': ->
    Session.set "title", "The worst buildings in NYC"
    Session.set "activeBorough", "all"
    Session.set 'activeLandlord', null
    console.log 'router: bldgs'
    enableMap()

  '/buildings/:borough': (borough) ->
    borough = borough.replace('-', ' ')
    Session.set "activeBorough", borough
    Session.set "title", "The worst buildings in " + (if borough is "Bronx" then "the " + borough else borough)
    Session.set 'activeLandlord', null
    console.log 'router: borough'
    enableMap()

  '/buildings/:borough/:building': (borough, building) ->
    console.log borough
    openBuilding(borough, building)
    Meteor.Router.to '/buildings/'+ borough +'/' + building + '/table'

  '/buildings/:borough/:building/:tab': (borough, building, tab) ->
    openBuilding(borough, building)
    Session.set "activeTab", tab
    #enableMap()
)


@enableMap = (right) ->
  $("body").addClass "left-sidebar-active"
  $("body").removeClass "right-sidebar-active" if !right?
  clearMap()
  Session.set "pageStart", 0
  window.changed = true
  "results"

@openBuilding = (borough, building) ->
  borough = borough.replace('-', ' ')
  Session.set "title", "The worst buildings in " + (if borough is "Bronx" then "the " + borough else borough) unless borough is 'all'
  Session.set "activeBorough", borough
  Session.set "openBuilding", building
  #buildingsSubscribe borough, 0
  $("body").addClass "right-sidebar-active"