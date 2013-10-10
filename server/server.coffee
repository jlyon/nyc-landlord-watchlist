# marker collection

#Buildings = new Meteor.Collection('buildings')
Meteor.publish 'buildings', (args) -> 
  console.log args
  queryBuildings args


#borough, page, activeLandlord, activeBounds
queryBuildings = (args) -> 
  search =
    lat: {$ne: 0}
    "exempt": {"$ne": 1}
  if args.borough? then if args.borough isnt 'all' then search.borough = args.borough # todo:  and args.borough not 'all'
  if !args.page? then args.page = 0 # todo: rm?

  # Retrieve the landlord record and run a search
  if args.activeLandlord? 
    landlord = Landlords.findOne {_id: args.activeLandlord}
    if landlord.bldg_ids?
      bldg_ids = landlord.bldg_ids
      if typeof bldg_ids isnt 'number'
        bldg_ids = bldg_ids.split ' '
        _.each bldg_ids, (num, index) ->
          bldg_ids[index] = parseInt(num)
        search = 
          bldg_id: {$in: bldg_ids}
      else
        search = 
          bldg_id: bldg_ids

  console.log search
  a = Buildings.find search
  console.log Object.keys(a.fetch()).length
  Buildings.find search, 
    limit: pageSize
    skip: args.page
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
    queryBuildings(
      borough: borough,
      page: page
    ).count()
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


# Active building
Meteor.publish 'building', (_id) -> 
  Landlords.find({_id: _id})


# User Stories
Meteor.publish 'stories', ->
  user = Meteor.user();
  if Roles.userIsInRole(user._id, ['admin'])
    Stories.find()

  else
    Stories.find({ published: true })

