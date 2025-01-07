// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require alertify.min
//= require i18n/es
//= require jquery.animateNumber.min
//= require sweetalert2.min
//= require store_notices

$(document).ready(function(){
  $('.btn').click(function(){
    if ($(this).attr('type') != 'submit' &&
        !$(this).hasClass('no-loading') && 
        !$(this).hasClass('delete-resource') && 
        !$(this).hasClass('js-show-index-filters') &&
        $(this).attr('id') != 'clear_cache' && 
        $(this).attr('id') != 'download-suscribed-users' && 
        !$(this).hasClass('edit-tracking') && 
        !$(this).hasClass('save-tracking') && 
        !$(this).hasClass('cancel-tracking') && 
        !$(this).hasClass('edit-alternative-tracking') && 
        !$(this).hasClass('save-alternative-tracking') && 
        !$(this).hasClass('cancel-alternative-tracking') && 
        !$(this).hasClass('dropdown-toggle btn') &&
        !$(this).hasClass('delete-image-btn') && 
        $(this).attr('id') != 'download-orders' &&
        $(this).attr('id') != 'download-orders-summary'
        ) {
      $(".loader-page").fadeIn();
    }
  });
  $(".loader-page").fadeOut("slow");

  var toggleAlertnativeTrackingEdit = function(event) {
    event.preventDefault();

    var link = $(this);
    link.parents('tbody').find('tr.edit-alternative-tracking').toggle();
    link.parents('tbody').find('tr.show-alternative-tracking').toggle();
  }

  // handle tracking edit click
  $('a.edit-alternative-tracking').click(toggleAlertnativeTrackingEdit);
  $('a.cancel-alternative-tracking').click(toggleAlertnativeTrackingEdit);

  $('[data-hook=admin_shipment_form] a.save-alternative-tracking').on('click', function (event) {
    event.preventDefault();

    var link = $(this);
    var shipment_number = link.data('shipment-number');
    var tracking = link.parents('tbody').find('input#alternative_tracking').val();
    var url = Spree.url(Spree.routes.shipments_api + '/' + shipment_number + '.json');
    console.log(tracking);

    $.ajax({
      type: 'PUT',
      url: url,
      data: {
        shipment: {
          alternative_tracking: tracking
        },
        token: Spree.api_key
      }
    }).done(function (data) {
      console.log(data);
      link.parents('tbody').find('tr.edit-alternative-tracking').toggle();

      var show = link.parents('tbody').find('tr.show-alternative-tracking');
      show.toggle();
      show.find('.tracking-value').html($("<strong>").html("Tracking Starken: ")).append(data.alternative_tracking);
    });
  });

  $('#download-orders').click(function(e){
    e.preventDefault();
    var url = $(this).attr('href');
    var params = $('#search-orders').serialize();
    document.location.href = `${url}?${params}`;
  });
});
