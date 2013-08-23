# marker collection

#Buildings = new Meteor.Collection('buildings')
Meteor.publish 'buildings', (borough, page) -> 
  queryBuildings borough, page

queryBuildings = (borough, page) -> 
  search = 
    lat: {$ne: 0}
  if borough? then search.borough = borough
  if !page? then page = 0
  Buildings.find search, 
    limit: pageSize
    skip: page
    sort:
      num: -1

###
Meteor.publish 'building', ->
  if id = Session.get("activeBuilding")
    Buildings.find {id: id}
###
###
({},
  fields:
    lat: true
    lng: true
    street_address: true
)
###

Meteor.methods(
  numBuildings: (borough, page) ->
    console.log(queryBuildings(borough, page).count())
    queryBuildings(borough, page).count()
)

  




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
  if data
    jsondata = JSON.parse(data)
  insert jsondata, Coll


# User Stories
Meteor.publish 'stories', ->
  user = Meteor.user();
  if Roles.userIsInRole(user._id, ['admin'])
    Stories.find()

  else
    Stories.find({ published: true })
