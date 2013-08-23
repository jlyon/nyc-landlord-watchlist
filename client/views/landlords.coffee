Template.landlords.helpers(
  data: ->
    data = Landlords.find().fetch()
    _.each data, (item, index) ->
      item.rank = index+1
    data
)

Template.landlords.events(
  'click a': (e) ->
    e.preventDefault()
    Session.set('activeBorough', this._id)
)


Template.landlord.helpers(
  building_text: ->
    if this.num_bldgs > 1 then "buildings" else "building"
)

Template.landlord.rendered = ->
  #collection ready, carousel not complete
  if landlordsReady()# and !$('.rs-carousel.rs-carousel-horizontal').length()
    $carousel = $('#landlord-carousel')
    $carousel.carousel(
      touch: true,
      pagination: false,
      create: (event, data) ->
        $('html').addClass('landlords');
    )
    $carousel.carousel('enable')
  

