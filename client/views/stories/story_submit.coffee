Template.storySubmit.helpers(
  test: ->
    console.log(this)
)

Template.storySubmit.events(
  'submit form': (event) ->
    event.preventDefault()

    story = {
      message: $(event.target).find('[name=message]').val()
    }

    Meteor.call 'post', story, (error, id) ->
      console.log('hello')
      if error
        Meteor.Statuses.create('error', error.reason);

)
