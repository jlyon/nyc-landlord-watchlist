# marker collection

Buildings = new Meteor.Collection('buildings')
Meteor.publish 'buildings', Buildings.find({}, {limit: 25})
###
({},
  fields:
    lat: true
    lng: true
    street_address: true
)
###
# landlord collection
Landlords = new Meteor.Collection('landlords')
console.log '%%'
console.log Landlords.findOne()
Meteor.publish 'landlords', Landlords.find()


# Load in data
#if Markers.find.count() is 0


Meteor.startup ->
  insertSample = (jsondata, Coll) ->
    _.each jsondata, (data) ->
      Fiber(->
        Coll.insert data
      ).run()

  if Landlords.find().count() is 0
    insertJSONfile("server/data/landlords.json", insertSample, Landlords)
  if Buildings.find().count() is 0
    insertJSONfile("server/data/buildings.json", insertSample, Buildings)

  console.log Buildings.findOne()


fs = __meteor_bootstrap__.require("fs")
insertJSONfile = (file, insert, Coll) ->
  jsondata = undefined
  fs.readFile file, (err, data) ->
    throw err  if err
    jsondata = JSON.parse(data)
    insert jsondata, Coll



