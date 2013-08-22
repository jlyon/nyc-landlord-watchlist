# marker collection

#Buildings = new Meteor.Collection('buildings')
Meteor.publish 'buildings', -> 
  Buildings.find {lat: {$ne: 0}}, 
    limit: 500
    sort:
      num: -1

Meteor.publish 'building', ->
  if id = Session.get("activeBuilding")
    Buildings.find {id: id}

###
({},
  fields:
    lat: true
    lng: true
    street_address: true
)
###

# landlord collection
Meteor.publish 'landlords', ->
  Landlords.find()

Meteor.startup ->
  insertSample = (jsondata, Coll) ->
    _.each jsondata, (data) ->
      Coll.insert data

  # Load in data if empty
  if Landlords.find().count() is 0
    insertJSONfile("data/landlords.json", insertSample, Landlords)
  if Buildings.find().count() is 0
    insertJSONfile("data/buildings.json", insertSample, Buildings)

insertJSONfile = (file, insert, Coll) ->
  jsondata = undefined
  data = Assets.getText file
  #console.log(err)
  #console.log(data)
  #throw err  if err
  if data
    #console.log(got it)
    jsondata = JSON.parse(data)
  #console.log(data)
  insert jsondata, Coll


# User Stories

Meteor.publish 'stories', ->
  user = Meteor.user();
  if Roles.userIsInRole(user._id, ['admin'])
    Stories.find()

  else
    Stories.find({ published: true })
