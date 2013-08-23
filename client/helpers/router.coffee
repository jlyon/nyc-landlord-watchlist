Meteor.Router.add(
  # Front
  '/':
    to: "landlords"
    and: ->
      Session.set "activePage", "landlords"
  '/buildings'
    to: "buildings"
    and: ->
      Session.set "activePage", "buidlings"
  '/buildings/:_borough'
    to: "buildings"
    and: (borough) ->
      Session.set "activeBorough", borough
      Session.set "activePage", "buidlings"
)
