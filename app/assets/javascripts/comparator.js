$(document).ready(function(){
  var scroll_trigger = 450;
  var max_scroll = $(document).height() - 800;
  var comparator_resume = $('#comparator-resume');
  var comparator_details = $('#comparator_details');

  $(window).on('scroll', function(){
    if ($(window).scrollTop() > scroll_trigger && $(window).scrollTop() < max_scroll) {
      if (comparator_resume.css('display') != 'flex') {
        comparator_resume.css('display', 'flex')
                         .hide()
                         .fadeIn(500);
      }
    }
    else {
      comparator_resume.fadeOut(500);
    }
  });

  comparator_details.on('scroll', function(){
    comparator_resume.scrollLeft($(this).scrollLeft());
  });

  comparator_resume.on('scroll', function(){
    comparator_details.scrollLeft($(this).scrollLeft());
  });

});