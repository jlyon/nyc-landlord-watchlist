@data_url = 'http://ec2-54-212-73-138.us-west-2.compute.amazonaws.com/feed.php?callback=?'
@vizColors = ['#394553', '#ff792f', '#acacac', '#4aa6d7', '#c5dffa', '#ff792f', '#fdc689', '#7cc576', '#9476c5', '#f8b3d1'];


Template.data.helpers
  bldg_id: ->
    return Session.get("openBuilding") 
  bldg: ->
    #console.log Session.get("activeBuilding")
    #console.log Buildings.find().fetch()
    #console.log Buildings.findOne({bldg_id: Session.get("openBuilding")})
    Buildings.findOne({bldg_id: Session.get("openBuilding")})

  activeCategory: ->
    activeTab = Session.get("activeTab")
    if Session.get("openBuilding")? and (activeTab? or activeTab is "category") then return 'active' else return ''
  activeTable: ->
    if Session.get("openBuilding")? and Session.get("activeTab") is "table" then return 'active' else return ''
  activeWordCloud: ->
    if Session.get("openBuilding")? and Session.get("activeTab") is "cloud" then return 'active' else return ''

Template.data.events
  'click a': (e) ->
    #e.preventDefault()
    #Session.get("activeTab")
    #console.log $(this

Template.data.rendered = ->
  #google.load 'visualization', '1', { packages: ['table', 'controls'] }



Template.dataCategory.rendered = ->
  query = 'SELECT x.a AS a, y.a AS a2,' \
          +' x.b AS b, y.b AS b2,' \
          +' x.c AS c, y.c AS c2,' \
          +' x.i AS i, y.i AS i2,' \
          +' x.num AS num, y.num AS num2' \
          +' FROM 2013_buildings_watchlist_final AS x' \
          +' LEFT JOIN 2012_buildings_watchlist_final AS y on x.bldg_id = y.bldg_id' \
          +' WHERE x.bldg_id = ' + Session.get("openBuilding")
  _get {query: query}, _drawCategories
  console.log query

Template.dataCategory.helpers
  dataLoading: ->
    return Session.get 'dataLoading'

_drawCategories = (data) ->
  Session.set 'dataLoading', false
  console.log data
  row = data.items[0]
  
  if (row?)
    arr = [
      ['Violation Class', '2013', '2012']
      ['Class A', parseInt(row.a), parseInt(row.a2)]
      ['Class B', parseInt(row.b), parseInt(row.b2)]
      ['Class C', parseInt(row.c), parseInt(row.c2)]
      ['Class I', parseInt(row.i), parseInt(row.i2)]
    ]

    google.visualization.drawChart
      containerId: 'dataCategory',
      dataTable: google.visualization.arrayToDataTable(arr),
      chartType: 'BarChart'
      options:
        title: 'Infractions by Category'
        #'width': 350,
        'height': 400,
        'is3D': true
        'tooltip': {showColorCode: true}
        vAxis: {title: 'Violation Class'}
        #legend: {position: 'none'},
        #chartArea: {width:"80%",height:"80%"},
        colors: vizColors



Template.dataTable.rendered = ->
  _get 
    query: 'SELECT date, class, description FROM 2013_violations_watchlist_final WHERE bldg_id = ' + Session.get("openBuilding")
    array_format: true
  , _drawTable

Template.dataTable.helpers
  dataLoading: ->
    return Session.get 'dataLoading'

_drawTable = (data) ->
  Session.set 'dataLoading', false
  row = data.items

  # Parse dates
  _.each data.items, (value, index) ->
    data.items[index][0] = new Date(parseInt(value[0].substr(4,4)), parseInt(value[0].substr(0,2)), parseInt(value[0].substr(2,2)))
    #value[2] = 'asdf' if !value[2]?

  # Put it into a Google object
  obj = new google.visualization.DataTable()
  obj.addColumn 'date', 'Date'
  obj.addColumn 'string', 'Violation Class'
  obj.addColumn 'string', 'Description'
  obj.addRows data.items

  # Define the class select
  classPicker = new google.visualization.ControlWrapper
    'controlType': 'CategoryFilter'
    'containerId': 'dataControlClass'
    'options':
      'filterColumnLabel': 'Violation Class'
      'ui':
        'labelStacking': 'vertical'
        'allowTyping': false
        'allowMultiple': true

  # Define the description search
  descriptionPicker = new google.visualization.ControlWrapper
    'controlType': 'StringFilter'
    'containerId': 'dataControlDescription'
    'options':
      'filterColumnLabel': 'Description'

  # Define the date range
  ###
  datePicker = new google.visualization.ControlWrapper
    'controlType': 'NumberRangeFilter'
    'containerId': 'dataControlDate'
    'options':
      'filterColumnLabel': 'Date'
      'ui':
        'labelStacking': 'vertical'
        'allowTyping': false
        'allowMultiple': true
  ###

  # Define a Table
  dataChart = new google.visualization.ChartWrapper
    'chartType': 'Table'
    'containerId': 'dataTable'
    'options':
      #'height': 630,
      #'width': window.innerWidth -68,
      'page': 'enable'
      'pageSize': 25
      'alternatingRowStyle': true
      'sortColumn': 0
      'sortAscending': false
      'cssClassNames': {headerRow: 'table-header-background', tableRow: 'table-row', oddTableRow: 'odd-table-row', selectedTableRow: 'google-hover-table-row', hoverTableRow: 'google-hover-table-row', headerCell: 'table-header-background', tableCell: '', rowNumberCell: ''}
    #'view': {'columns': [0, 1]}

  # Create a dashboard
  new google.visualization.Dashboard(document.getElementById('dataDashboard')).
    #bind(datePicker, dataChart).
    bind(classPicker, dataChart).
    bind(descriptionPicker, dataChart).
    draw obj


Template.dataWordCloud.rendered = ->
  _get 
    query: 'SELECT description FROM 2013_violations_watchlist_final WHERE bldg_id = ' + Session.get("openBuilding")
    array_format: true
  , _drawTable

Template.dataWordCloud.helpers
  dataLoading: ->
    return Session.get 'dataLoading'

_drawWordCloud = (data) ->
  Session.set 'dataLoading', false

  # Parse dates
  ###
  description = []
  _.each data.items, (value, index) ->
    data.items[index][0] = new Date(parseInt(value[0].substr(4,4)), parseInt(value[0].substr(0,2)), parseInt(value[0].substr(2,2)))
    value[2] = 'asdf' if !value[2]?
    description.push [value[2]]
  ###
  console.log data

  obj = new google.visualization.DataTable()
  obj.addColumn 'string', 'Description'
  obj.addRows data
  wc = new WordCloud(document.getElementById('dataWordCloud'))
  wc.draw obj, null

_get = (data, successCallback) ->
  $.ajax
    dataType: "json"
    url: data_url
    data: data
    success: (data) ->
      successCallback(data)


