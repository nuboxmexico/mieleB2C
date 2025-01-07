$(document).ready(function(){
  $('.option').click(function(){
    $('.option').removeClass('selected').addClass('unselected');
    $(this).addClass('selected');
    $('#shipping-address-container').slideDown();
    $('#continue-on-down').prop('disabled', false);
  });

  $('input[name="options"]').change(function(){
    if ($(this).val() == 'bill') {
      $('#billing-address-container').slideDown();
    }
    else {
      $('#billing-address-container').slideUp();
    }
  });

});