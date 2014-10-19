# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


fetchTweetCount = ->
    $('#gobutton').on 'click', ->
      $.each window.coordinates, (state, geocode) ->
        # get tweet count for query
        $.ajax {
          type: 'POST'
          url: '/fetch_tweets' 
          data: { criteria: { query: $('#query').val(), geocode: geocode }, authenticity_token: $('#authenticity_token').val()}
          success: (count) ->
            point = ''
            $.each($('#container').highcharts().series[0].points, (i,e) -> 
              if(e['hc-key'] == state) 
                point = e
            )
            point.update(parseInt(count))
          fail: ->
            console.log 'Error'    
        }

chooseCountry = ->
  $('#country_select').on 'change', ->
    fetchCoordinates()
    renderMap()

fetchCoordinates = ->
  $.getJSON 'countries/' + $('#country_select').val() + '.json', (coordinates) ->
    window.coordinates = coordinates

linkEvents = ->
  fetchTweetCount()
  chooseCountry()

renderMap = (result) ->
  country = $("#country_select").val()
  map_url = 'countries/' + country + '/' + country + '-all'
  $("#container").highcharts "Map",
    title:
      text: ''
    subtitle:
      text: ''

    mapNavigation:
      enabled: false
      buttonOptions:
        verticalAlign: "bottom"

    colorAxis:
      min: 0

    series: [
      data: result
      mapData: Highcharts.maps[map_url]
      joinBy: "hc-key"
      name: "Tweets Count for"
      states:
        hover:
          color: "#BADA55"

      dataLabels:
        enabled: true
        format: "{point.name}"
    ]

  $(".highcharts-background").attr fill: "lightsteelblue"

$ ->
  renderMap()
  fetchCoordinates()
  linkEvents()
