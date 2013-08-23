submitForm = (e) ->
  media = []

  $(e.target).find('.media-item').each( ->
    console.log(this)
    media.push(
      image: $(this).find('img').attr('src')
      description: $(this).find('textarea').val()
    )
  )
  
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

Template.storySubmit.addImages = (imgData) ->
  $('#storyMedia .well .empty-text').remove()
  console.log(imgData)
  _.each imgData, (file, num) ->
    console.log(file)
    fragment = Meteor.render -> 
      #this calls the template and returns the HTML.
      Template.storySubmitImage(file)
    # put in content
    $('#storyMedia .well').append(fragment)

Template.storySubmit.popupSubmit = (e) ->
  e.preventDefault()
  submitForm(e)

Template.storySubmit.events(
  'click #storyTab a': (e) ->
    e.preventDefault()

  'popupSubmit': (e) ->
    e.preventDefault()
    submitForm(e)

  'submit form': (e) ->
    e.preventDefault()
    submitForm(e)
)

###


filename: "user-default.png"
isWriteable: true
key: "7AyFC3uJRxKfwVn0ZMGY_user-default.png"
mimetype: "image/png"
size: 2207
url: "https://www.filepicker.io/api/file/UYjSONRLQBqTFsePdzjU"


###

Template.storySubmitImage.helpers(
  type: ->
    console.log(this)

  image: ->
    console.log(this)

  content: ->
    console.log(this)
    '<img src="' + this.url + '">'
)