###
Template.header.helpers(
  active: ->
    return Session.get('activeBorough') is this._id
)
###

Template.boroughs.events(
  'click a': (e) ->
    Session.set('activeBorough', this._id)
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
    ###_.each boroughs, (item, index) ->
       boroughs[index].active = 'active'
    console.log boroughs
    ###
    boroughs

  active: ->
    console.log 'a'
    if Session.get "activeBorough" is this.link then return 'active'
    return ''
)
