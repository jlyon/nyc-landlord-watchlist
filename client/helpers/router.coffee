Meteor.Router.add(
  # Front
  '/': {
    as: 'front',
    to: 'main'
  }
)

Meteor.Router.filters(
  'requireLogin': (page) ->
    if Meteor.user()
      page
    else if Meteor.loggingIn()
      'loading'
    else
      'login'
)