var timeout;

$(document).ready(function(){
  $('.sub-family-container').hide();
  $('.sub-category-container').css('top', $('#header').outerHeight());
  $('.header-category').hover(
    function(){
      $('.sub-category-container').hide();
      $('#'+$(this).data('category')+'-category').show();
      $(".overlay").show();
    },
    function() {
      var category_class = '#'+$(this).data('category')+'-category'
      $(category_class).hide();
      $(".overlay").hide();
    }
  );

  $('.header-sub-category').hover(
    function(){
      clearTimeout(timeout);
      $('.sub-family-container').hide();
      $('#'+$(this).data('category')+'-sub-category').show();
    },
    function() {
      var category_class = '#'+$(this).data('category')+'-sub-category'
      timeout = setTimeout(function(){
        $(category_class).hide();
      }, 1000);
      
    }
  );

  $('.header-specific').hover(
    function(){
      clearTimeout(timeout);
      $('.specific-list').addClass('specific-list-hide');
      $('.'+$(this).data('category')+'-specific').show();
      $('.'+$(this).data('category')+'-specific').removeClass('specific-list-hide');
      
    },
    function() {
      var category_class = '.'+$(this).data('category')+'-specific'
      timeout = setTimeout(function(){
        $(category_class).hide();
        $(category_class).addClass('specific-list-hide');
      }, 1000);
      
    }
  );
});