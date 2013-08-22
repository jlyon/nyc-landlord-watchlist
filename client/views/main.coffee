###
Template.header.helpers(
  active: ->
    return Session.get('activeBorough') is this._id
)
###

Template.boroughs.events(
  'click a': (e) ->
    e.preventDefault()
    Session.set('activeBorough', this.link)
    console.log Session.get "activeBorough"
)

Template.boroughs.helpers(
  #Session.activeBorough null
  boroughs: ->
    boroughs = [
      label: "All buildings"
      link: "All buildings"
    ,
      label: "Bronx"
      link: "Bronx"
    ,
      label: "Brooklyn"
      link: "Brooklyn"
    ,
      label: "Manhattan"
      link: "Manhattan"
    ,
      label: "Queens"
      link: "Queens"
    ,
      label: "Staten Island"
      link: "Staten Island"
    ]
)

Template.borough.helpers(
  active: ->
    current = Session.get "activeBorough"
    if current is this.link then return 'active'
    return ''
)

bootstrapPopSelector = (args) ->
  '#' + args.modalType + '-modal-'+ args.id

Template.bootstrapPop.empty = () ->
  Session.set('bootstrapPop', false)

Template.bootstrapPop.hide = () ->
  $(bootstrapPopSelector(window.bootstrapPopArgs)).modal('hide')

Template.bootstrapPop.setup = (args) ->
  _.extend(window, {bootstrapPopArgs: args})
  Session.set('bootstrapPop', true)

Template.bootstrapPop.helpers(
  isAvailable: ->
    Session.get 'bootstrapPop'

  getArgs: ->
    console.log(this)
    this.bootstrapPopArgs
)

Template.bootstrapPop.events(
  "click .close-pop, click .close": (e) ->
    e.preventDefault()

  "click .submit": (e) ->
    e.preventDefault()
    args = window.bootstrapPopArgs
    if args.contentTemplate
      Template[args.contentTemplate].popupSubmit(e)

)

Template.bootstrapPop.rendered = ->
  # in session
  if Session.get 'bootstrapPop'
    # grab args
    args = window.bootstrapPopArgs
    if !args.contentRendered
      modal = bootstrapPopSelector(args)

      # using template to render
      if args.contentTemplate
        # render a template
        fragment = Meteor.render -> 
          #this calls the template and returns the HTML.
          Template[args.contentTemplate](args)
        # put in content
        $(modal + " .modal-body").append(fragment)
        
        $(modal).modal()

        # using modal controls
        if args.footer
          $(modal + " .modal-body div.submit").hide()

      $(modal).on 'hidden.bs.modal', ->
        Session.set('bootstrapPop', false)

      window.bootstrapPopArgs.contentRendered = true

Template.bootstrapPop.created = ->
  Session.set('bootstrapPop', false)
  console.log('hello')
