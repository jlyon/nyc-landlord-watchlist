Template.meteorStatuses.helpers({
  statuses: function() {
    return Meteor.statuses.find();
  }
});

Template.meteorStatus.rendered = function() {
  var status = this.data;
  Meteor.defer(function() {
    Meteor.statuses.update(status._id, {$set: {seen: true}});
  });
};
