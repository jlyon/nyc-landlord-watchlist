Meteor.Router.add(
  '/': ->
    Session.set "activePage", "landlords"
    $("body").removeClass "left-sidebar-active"
    "landlords"

  'buildings': ->
      alert "asdf"
      Session.set "activePage", "buidlings"
      console.log "buildings"
      $("body").addClass "left-sidebar-active"
      "results"

  '/buildings/:borough': (borough) ->
      Session.set "activeBorough", borough.replace('_', ' ')
      Session.set "activePage", "buidlings"
      $("body").addClass "left-sidebar-active"
      "results"
)
