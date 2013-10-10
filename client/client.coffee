Deps.autorun ->
  console.log('autorun')
  window.buildingsHandle = Meteor.subscribe 'buildings',
    borough: Session.get 'activeBorough'
    page: Session.get "pageStart"
    activeLandlord: Session.get 'activeLandlord'
    activeBounds: null

# Trigger Deps.autorun
Session.set "pageStart", 0

@landlordsHandle = Meteor.subscribe 'landlords'

@isReady = ->
  console.log 'isReady'
  landlordsReady() and buildingsReady()

@landlordsReady = ->
  landlordsHandle && landlordsHandle.ready()

@buildingsReady = ->
  window.buildingsHandle && window.buildingsHandle.ready()

@buildingsSubscribe = (borough, startPage, activeLandlord, activeBounds)->
  ###
  window.buildingsHandle.stop()
  console.log activeLandlord
  console.log borough
  console.log startPage
  console.log('SUBSCRIBE')
  
  
  @buildingsHandle = Meteor.subscribe 'buildings', borough: borough, startPage, activeLandlord, activeBounds
  ###

