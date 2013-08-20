# Create the Pages collection
@Stories = new Meteor.Collection('stories')

Stories.allow({
  update: ownsOrAdmin
})

Meteor.methods(
  newStory: (pageAttributes) ->
    user = Meteor.user();

    #pick out the whitelisted keys
    Story = _.extend(storyAttributes, {
      submitted: new Date().getTime(),
      published: false
    })

    return storyId

  publishStory: (pageAttributes) ->
    user = Meteor.user()
)
