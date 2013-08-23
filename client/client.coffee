@buildingsHandle = Meteor.subscribe 'buildings'
@landlordsHandle = Meteor.subscribe 'landlords'

@isReady = ->
  buildingsHandle && buildingsHandle.ready() && landlordsHandle && landlordsHandle.ready()

@landlordsReady = ->
  landlordsHandle && landlordsHandle.ready()

@buildingSubscribe = (borough, startPage)->
  @buildingsHandle.stop()
  console.log startPage
  Session.set "borough", borough
  Session.set "startPage", startPage
  @buildingsHandle = Meteor.subscribe 'buildings', borough, startPage