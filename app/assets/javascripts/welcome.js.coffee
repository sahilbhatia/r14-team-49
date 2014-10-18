# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # Initiate the chart
  $("#container").highcharts "Map",
    title:
      text: ''
    subtitle:
      text: "Source map: <a href=\"http://code.highcharts.com/mapdata/countries/in/in-all.js\">India</a>"

    mapNavigation:
      enabled: true
      buttonOptions:
        verticalAlign: "bottom"

    colorAxis:
      min: 0

    series: [
      data: data
      mapData: Highcharts.maps["countries/in/in-all"]
      joinBy: "hc-key"
      name: "Random data"
      states:
        hover:
          color: "#BADA55"

      dataLabels:
        enabled: true
        format: "{point.name}"
    ]

  $(".highcharts-background").attr fill: "lightsteelblue"
  return

