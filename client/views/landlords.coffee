Template.landlords.helpers(
  data: ->
    data = Landlords.find().fetch()
    imgs = '';
    _.each data, (item, index) ->
      item.rank = index+1
      # this is just used to generate a list of wget cmds to dl goog streetview imgs for landlords
      imgs += 'wget "http://maps.googleapis.com/maps/api/streetview?size=225x170&location=' + \
        encodeURIComponent(item.bldg_address) + '&sensor=false" ' + \
        '-O landlord-' + item.rank + '.jpg'+"\r\n";
    #console.log imgs
    data

  hero: ->
    !Session.get("activeLandlord")?

  show: ->
    Session.get("activeLandlord")? or Session.get("title") is "Landlords"
)

Template.landlord.events(
  'click': (e) ->
    e.preventDefault()
    console.log(this.rank*360)
    $('#landlord-carousel .thumbnails').css('left', - this.rank*360 + 'px')
    Meteor.Router.to "/landlords/" + this._id
)


Template.landlord.helpers(
  building_text: ->
    if this.num_bldgs > 1 then "buildings" else "building"
)

Template.landlordProfile.helpers(
  building_text: ->
    if this.num_bldgs > 1 then "buildings" else "building"
)

Template.landlords.rendered = ->
  #collection ready, carousel not complete
  #if !window.initLandlord? and landlordsReady()# and !$('.rs-carousel.rs-carousel-horizontal').length()
  console.log 'Landlord ren'
  $carousel = $('#landlord-carousel')
  $carousel.carousel(
    touch: true,
    pagination: false,
    create: (event, data) ->
      $('html').addClass('landlords');
  )
  $carousel.carousel('enable')
  window.initLandlord = true

