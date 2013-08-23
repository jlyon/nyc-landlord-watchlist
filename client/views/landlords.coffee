Template.landlords.helpers(
  data: ->
    data = Landlords.find().fetch()
    _.each data, (item, index) ->
      item.rank = index+1
    data
)

Template.landlords.events(
  'click a': (e) ->
    e.preventDefault()
    Session.set('activeBorough', this._id)
)


Template.landlord.helpers(
  building_text: ->
    if this.num_bldgs > 1 then "buildings" else "building"
)
