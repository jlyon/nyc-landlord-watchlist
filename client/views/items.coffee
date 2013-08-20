Template.buildingListItem.helpers(
  active: ->
    return Session.get('activeBuilding') is this._id
)

Template.buildingListItem.events(
  'click .title': (e) ->
    alert('adsf')
    Session.set('activeBuilding', this._id)

  'click .share-story': (e) ->
  	#render item template
    fragment = Meteor.render -> 
      #this calls the template and returns the HTML.
      Template['storySubmit'](this)
      
    # append
    $('body').append(fragment)
)
