Tinytest.add("Status collection works", function(test) {
  test.equal(Meteor.statuses.find({}).count(), 0);

  Meteor.Statuses.create('notification', 'A new status!');
  test.equal(Meteor.statuses.find({}).count(), 1);

  Meteor.statuses.remove({});
});

Tinytest.addAsync("Status template works", function(test, done) {
  Meteor.Statuses.create('notification', 'A new status!');
  test.equal(Meteor.statuses.find({seen: false}).count(), 1);

  // render the template
  OnscreenDiv(Spark.render(function() {
    return Template.meteorStatuses();
  }));

  // wait a few milliseconds
  Meteor.setTimeout(function() {
    test.equal(Meteor.statuses.find({seen: false}).count(), 0);
    test.equal(Meteor.statuses.find({}).count(), 1);
    Meteor.Statuses.clear();

    test.equal(Meteor.statuses.find({seen: true}).count(), 0);
    done();
  }, 500);
});
