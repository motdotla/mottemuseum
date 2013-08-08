$ ->
  DD_belatedPNG.fix "#navigation, #logo a, p.title, .slider-shadow, .bottom, .twitter, .facebook, .thumb, .slider-wrap, .slider-2-wrap, .slider-2-shadow, .slider-3-wrap, .slider-3-shadow, .morephotos"  if $.browser.msie and $.browser.version < 7
  $(document).on("focusin", ".field, textarea", ->
    @value = ""  if @title is @value
  ).on "focusout", ".field, textarea", ->
    @value = @title  if @value is ""

  $("#slider").flexslider
    animation: "slide"
    directionNav: false
    start: (slider) ->
      $("#slider .title").append $(".flex-control-nav")
      $("#slider .flex-control-nav li a").text ""
      slide = slider.currentSlide
      title = $("#slider .slides li:eq(" + (slide + 1) + ") img").attr("alt")
      $("#slider p.title span").text title

    before: (slider) ->
      $("#slider p.title span").fadeOut 500

    after: (slider) ->
      slide = slider.currentSlide
      title = $("#slider .slides li:eq(" + (slide + 1) + ") img").attr("alt")
      $("#slider p.title span").text(title).fadeIn 500

  $("#slider2").flexslider
    animation: "slide"
    directionNav: false
    start: (slider) ->
      $("#slider2 .flex-control-nav li a").text ""

  $("#slider3").flexslider
    animation: "slide"
    directionNav: false
    start: (slider) ->
      $("#slider3 .flex-control-nav li a").text ""