buildingsPop = (building) ->
  _.extend(building,
    {
      id: building._id,
      modalType: "story",
      title: "Submit a story",
      contentTemplate: "storySubmit",
      submitText: "submit",
      footer: true
    }
  )

Template.buildingListItem.helpers(
  active: ->
    return Session.get('activeBuilding') is this._id
)

Template.buildingListItem.events(
  'click .title': (e) ->
    alert('adsf')
    e.preventDefault()
    Session.set('activeBuilding', this._id)

  'click .share-story': (e) ->
  	#render item template
    e.preventDefault()
    Template['bootstrapPop'].setup(buildingsPop(this))
)
