@buildingsHandle = Meteor.subscribe 'buildings'
@landlordsHandle = Meteor.subscribe 'landlords'

@isReady = ->
  buildingsHandle && buildingsHandle.ready() && landlordsHandle && landlordsHandle.ready()

@landlordsReady = ->
  landlordsHandle && landlordsHandle.ready()

@buildingsSubscribe = (borough, startPage, activeLandlord, activeBounds)->
  @buildingsHandle.stop()
  console.log activeLandlord
  console.log borough
  console.log startPage
  Session.set "borough", borough
  Session.set "startPage", startPage
  @buildingsHandle = Meteor.subscribe 'buildings', borough, startPage, activeLandlord, activeBounds

