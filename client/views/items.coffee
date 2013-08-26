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
    if Session.get('activeBuilding') is this._id then "active" else ""
)

Template.buildingListItem.events(
  'click .title': (e) ->
    openPopup this
    setCenter this
    e.preventDefault()

  'click .share-story': (e) ->
  	#render item template
    Template['bootstrapPop'].setup(buildingsPop(this))
    e.preventDefault()

  'click .see-details': (e) ->
    e.preventDefault()
    openPopup this
    $("body").addClass "right-sidebar-active"
    resizeMap()
)
