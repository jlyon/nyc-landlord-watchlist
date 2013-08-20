Template.header.helpers(
  active: ->
    return Session.get('activeBorough') is this._id
)

Template.header.events(
  'click a': (e) ->
    Session.set('activeBorough', this.link)
    console.log Session.get "activeBorough"
)

Template.boroughs.helpers(
  #Session.activeBorough null
  boroughs: ->
    boroughs = [
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

Template.borough.helpers(
  active: ->
    current = Session.get "activeBorough"
    if current is this.link then return 'active'
    return ''
)
