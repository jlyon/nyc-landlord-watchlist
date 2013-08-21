submitForm = (e) ->
  console.log("hahahah")
  
  story = {
    email: $(e.target).find('[name=email]').val()
    message: $(e.target).find('[name=message]').val()
  }

  Meteor.call 'newStory', story, (error, id) ->
    if error
      console.log('error' + error.reason)
      Meteor.Statuses.create('error', error.reason)
    else
      console.log('here')
      Meteor.Statuses.create('success', "Your story has been submitted")
      Template.bootstrapPop.hide()

Template.storySubmit.popupSubmit = (e) ->
  e.preventDefault()
  submitForm(e)

Template.storySubmit.events(
  'click #storyTab a': (e) ->
    #e.preventDefault()

  'popupSubmit': (e) ->
    e.preventDefault()
    submitForm(e)

  'submit form': (e) ->
    e.preventDefault()
    submitForm(e)
)
