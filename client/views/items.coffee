Template.buildingListItem.helpers(
  active: ->
    return Session.get('activeBuilding') is this._id
)

Template.buildingListItem.events(
  'click ': (e) ->
    alert('adsf')
    Session.set('activeBuilding', this._id)
)
