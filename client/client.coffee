@buildingsHandle = Meteor.subscribe 'buildings'
@landlordsHandle = Meteor.subscribe 'landlords'

@isReady = ->
  buildingsHandle && buildingsHandle.ready() && landlordsHandle && landlordsHandle.ready()
