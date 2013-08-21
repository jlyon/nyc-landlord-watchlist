# Create the Pages collection
@Stories = new Meteor.Collection('stories')

Stories.allow({
  update: ownsOrAdmin
})

Meteor.methods(
  newStory: (storyAttributes) ->
    user = Meteor.user();

    #pick out the whitelisted keys
    Story = _.extend(storyAttributes, {
      submitted: new Date().getTime(),
      published: false
    })

    storyId = Stories.insert(Story)

    return storyId

  publishStory: (pageAttributes) ->
    user = Meteor.user()
)
