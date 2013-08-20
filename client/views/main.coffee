Template.header.helpers(
  active: ->
    return Session.get('activeBorough') is this._id
)

Template.header.events(
  'click a': (e) ->
    Session.set('activeBorough', this._id)
)



Template.boroughs.helpers(
  boroughs: ->
    return [
      label: "All buildings"
      link: "All buildings"
    ,
      label: "Bronx"
      link: "Bronx"
    ,
      label: "Brooklyn"
      link: "Brooklyn"
    ,
      label: "Manhattan"
      link: "Manhattan"
    ,
      label: "Queens"
      link: "Queens"
    ,
      label: "Staten Island"
      link: "Staten Island"
    ]
)