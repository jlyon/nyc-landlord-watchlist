// Local (client-only) collection
Meteor.statuses = new Meteor.Collection(null);

Meteor.Statuses = {
  create: function(type, message) {
    Meteor.statuses.insert({type: type, message: message, seen: false});
  },
  clear: function() {
    Meteor.statuses.remove({seen: true});
  }
}
