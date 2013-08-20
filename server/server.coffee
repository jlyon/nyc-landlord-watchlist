# marker collection

#Buildings = new Meteor.Collection('buildings')
Meteor.publish 'buildings', -> 
  return Buildings.find({}, {limit: 25})

###
({},
  fields:
    lat: true
    lng: true
    street_address: true
)
###
# landlord collection
#Landlords = new Meteor.Collection('landlords')
console.log '%%'
Meteor.publish 'landlords', ->
  return Landlords.find()

# Load in data
#if Markers.find.count() is 0


Meteor.startup ->
  insertSample = (jsondata, Coll) ->
    _.each jsondata, (data) ->
      Coll.insert data

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



