@buildingsHandle = Meteor.subscribe 'buildings'
@landlordsHandle = Meteor.subscribe 'landlords'

@isReady = ->
  buildingsHandle && buildingsHandle.ready() && landlordsHandle && landlordsHandle.ready()

@buildingSubscribe = (borough, startPage)->
  @buildingsHandle.stop()
  @buildingsHandle = Meteor.subscribe 'buildings', borough, startPage