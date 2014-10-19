﻿# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


fetchTweetCount = ->
    $('#fetch_button').on 'click', (e) ->
      progress = 0
      window.toSearch = true
      $(this).attr('disabled', 'disabled')
      $('#query').attr('disabled', 'disabled')

      $('#container').highcharts().series[0].setData([])
      $('#fetch_button').progressSet(1)
      $('#cancel').removeClass('hide')
      
      $.each window.coordinates, (state, geocode) ->
        # get tweet count for given query
        if window.toSearch is true
            $.ajax {
              type: 'POST'
              url: '/fetch_tweets' 
              data: { criteria: { query: $('#query').val(), geocode: geocode }, authenticity_token: $('#authenticity_token').val()}
              success: (count) ->
                $('#fetch_button').progressSet(setCurrentProgress(progress += 1))
                if Object.keys(window.coordinates).length is progress
                  $('#fetch_button').attr('disabled', false)
                  $('#query').attr('disabled', false)
                
                # render tweet count on map
                point = ''
                $.each($('#container').highcharts().series[0].points, (i,e) -> 
                  if(e['hc-key'] == state) 
                    point = e
                )
               
                if point 
                  point.update(parseInt(count))
                
                  $.amaran({
                    content:{
                      bgcolor: '#27ae60',
                      color: '#fff',
                      message: point.name + ' : ' + count
                    },
                    theme:'colorful'
                  });
              error: ->
                cancelSerach()
                jqXHR.abort()
            }

onCancel = ->
  $('#cancel').on 'click', ->
    cancelSerach()

cancelSerach = ->
  window.toSearch = false
  $('#cancel').hide()
  $('#query').attr('disabled', false)
  initiateSearch()

window.setCurrentProgress = (progress) ->
  (progress / Object.keys(window.coordinates).length) * 100

chooseCountry = ->
  $('#country_select').on 'change', ->
    fetchCoordinates()
    renderMap()

fetchCoordinates = ->
  $.getJSON 'countries/' + $('#country_select').val() + '.json', (coordinates) ->
    window.coordinates = coordinates

onQueryChange = ->
  $('#fetch_button').attr('disabled', 'disabled')
  $('#query').on 'keyup', ->
    unless $(this).val().trim()
      $('#fetch_button').attr('disabled', 'disabled')
    else
      $('#fetch_button').attr('disabled', false)

linkEvents = ->
  fetchTweetCount()
  chooseCountry()
  onQueryChange()
  onCancel()

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
    
    plotOptions: 
      mapbubble:
        animation: true

  $(".highcharts-background").attr fill: "lightsteelblue"

initiateSearch = ->
  $('#fetch_button').progressSet(100)
  renderMap()

$ ->
  initiateSearch()
  fetchCoordinates()
  linkEvents()
