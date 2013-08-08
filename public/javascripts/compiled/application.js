(function() {
  $(function() {
    if ($.browser.msie && $.browser.version < 7) {
      DD_belatedPNG.fix("#navigation, #logo a, p.title, .slider-shadow, .bottom, .twitter, .facebook, .thumb, .slider-wrap, .slider-2-wrap, .slider-2-shadow, .slider-3-wrap, .slider-3-shadow, .morephotos");
    }
    $(document).on("focusin", ".field, textarea", function() {
      if (this.title === this.value) {
        return this.value = "";
      }
    }).on("focusout", ".field, textarea", function() {
      if (this.value === "") {
        return this.value = this.title;
      }
    });
    $("#slider").flexslider({
      animation: "slide",
      directionNav: false,
      start: function(slider) {
        var slide, title;
        $("#slider .title").append($(".flex-control-nav"));
        $("#slider .flex-control-nav li a").text("");
        slide = slider.currentSlide;
        title = $("#slider .slides li:eq(" + (slide + 1) + ") img").attr("alt");
        return $("#slider p.title span").text(title);
      },
      before: function(slider) {
        return $("#slider p.title span").fadeOut(500);
      },
      after: function(slider) {
        var slide, title;
        slide = slider.currentSlide;
        title = $("#slider .slides li:eq(" + (slide + 1) + ") img").attr("alt");
        return $("#slider p.title span").text(title).fadeIn(500);
      }
    });
    $("#slider2").flexslider({
      animation: "slide",
      directionNav: false,
      start: function(slider) {
        return $("#slider2 .flex-control-nav li a").text("");
      }
    });
    return $("#slider3").flexslider({
      animation: "slide",
      directionNav: false,
      start: function(slider) {
        return $("#slider3 .flex-control-nav li a").text("");
      }
    });
  });
}).call(this);
