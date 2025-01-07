$(document).ready(function(){
  $('.specific-attribute-container h4').click(function(){
    var container = $(this).parent();
    if (!container.hasClass('active')) {
      slideUpAllSpecificAttributes($('.specific-attribute-container'));
      container.addClass('active');
      container.find('div').slideDown('slow');
    }
    else {
      container.removeClass('active');
      container.addClass('slide-up');
      container.find('div').slideUp('slow', function(){
        container.removeClass('slide-up');
      });
    }
  });

  $('.active h4').on('click', function(){
    console.log('asdfas');
    var container = $(this).parent();
  })
});

function slideUpAllSpecificAttributes(container) {
  if (container.hasClass('active')) {
    container.removeClass('active');
    container.addClass('slide-up');
    container.find('div').slideUp('slow', function(){
      container.removeClass('slide-up');
    });
  }
}