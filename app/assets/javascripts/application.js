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
// Puede agregar turbolinks
//
//= require jquery
//= require jquery_ujs
//= require alertify.min
//= require spree/frontend.js
//= require i18n/es
//= require jquery.animateNumber.min
//= require sweetalert2.min
//= require ahoy
//= require inputmask.min
//= require react
//= require react_ujs
//= require components
//= require ReactRouter.min
//= require react-numeric-input.min
//= require prop-types.min
//= require select2.min
//= require rutvalidator
//= require material.min
//= require categories
//= require miele
//= require checkout
//= require comparator
//= require product
//= require mobile_categories
//= require search
//= require simple-scrollbar.min
//= require swiper.min
//= require slick.min
//= require newsletter_popup
//= require_tree.

//$(document).on('turbolinks:load', function() {
  $(document).ready(function() {
    SimpleScrollbar.initAll();
    var selectors = document.querySelectorAll(".phone-input");
    if (selectors && selectors.length > 0) {
      if (selectors.length == 1) {
        selectors = [selectors];
      }
      var im = new Inputmask("+(56\\9) 9999 9999");
      for (var i = 0; i < selectors.length; i++) {
        im.mask(selectors[i]);
      }
    }

    Spree.fetch_cart();
    $(window).scrollTop(0);
    // FacebookSDK
    // Mobile compatibility
    setTimeout(function(){
      if($(".fb-customerchat").html() == undefined){
        $("#fb-mobile-check").html(
          '<a href="https://m.me/GarageLabs" target="_blank">'+
          '<div style="background: none; border-radius: 50%; bottom: 18pt; box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 12px; display: inline; height: 45pt; padding: 0px; position: fixed; right: 18pt; top: auto; width: 45pt; z-index: 2147483646;">'+
          '<div tabindex="0" role="button" style="cursor: pointer; outline: none;"><svg width="60px" height="60px" viewBox="0 0 60 60"><svg x="0" y="0" width="60" height="60"><defs><linearGradient x1="50%" y1="100%" x2="50%" y2="0.000340050378%" id="linearGradient-1"><stop stop-color="#0068FF" offset="4.5%"></stop><stop stop-color="#00C6FF" offset="95.5%"></stop></linearGradient></defs><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g><g><circle fill="#FFFFFF" cx="30" cy="30" r="30"></circle><g transform="translate(10.000000, 11.000000)"><path d="M0,18.7150914 C0,24.5969773 2.44929143,29.6044708 6.95652174,33.0434783 L6.95652174,40 L14.2544529,36.6459314 C16.0763359,37.1551856 18,37.4301829 20,37.4301829 C31.043257,37.4301829 40,29.0529515 40,18.7150914 C40,8.37723141 31.043257,0 20,0 C8.956743,0 0,8.37723141 0,18.7150914 Z" fill="url(#linearGradient-1)"></path><polygon fill="#FFFFFF" points="16.9378907 19.359375 7 25 17.8976562 13.140625 23.0570312 18.640625 33 13 22.1023437 24.859375"></polygon></g></g></g></g></svg></svg></div>'+
          '</div>'+  
          '</a>'
          );
      }
    } ,2000);
    alertify.set('notifier','position', 'top-right');
    alertify.set('notifier','delay', 5);
    // Array.prototype.removeVal = function(val) {
    //     for (var i = 0; i < this.length; i++) {
    //         if (this[i] === val) {
    //             this.splice(i, 1);
    //             i--;
    //         }
    //     }
    //     return this;
    // }
    Number.prototype.formatMoney = function(places, symbol, thousand, decimal) {
      places = !isNaN(places = Math.abs(places)) ? places : 2;
      symbol = symbol !== undefined ? symbol : "$";
      thousand = thousand || ",";
      decimal = decimal || ".";
      var number = this, 
      negative = number < 0 ? "-" : "",
      i = parseInt(number = Math.abs(+number || 0).toFixed(places), 10) + "",
      j = (j = i.length) > 3 ? j % 3 : 0;
      return symbol + negative + (j ? i.substr(0, j) + thousand : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousand) + (places ? decimal + Math.abs(number - i).toFixed(places).slice(2) : "");
    };
    $('.tree-toggle-nav').click(function () {
      $(this).parent().children('ul.tree-nav').toggle(200);
    });
    $('.dropdown-toggle').dropdown();
    scroll_top();

    $('#checkout_form_address').validate({
      errorPlacement: function(error, element) {
        error_tag = $('<span class="mdl-textfield__error">' + error.text() + '</span>');
        element.parent().addClass('is-invalid');
        element.parent().find('.mdl-textfield__error').remove();
        element.parent().append(error_tag);
      }
    });

    Inputmask.extendDefaults({
      'autoUnmask': true
    });

    if ($('#products-in-offer-container').length == 0) {
      $(".loader-page").fadeOut("slow");
    }
  });
function scroll_top(){
  if ($('#back-to-top').length) {
    var scrollTrigger = 100, // px
    backToTop = function () {
      var scrollTop = $(window).scrollTop();
      if (scrollTop > scrollTrigger) {
        $('#back-to-top').addClass('show');
      } else {
        $('#back-to-top').removeClass('show');
      }
    };
    backToTop();
    $(window).on('scroll', function () {
      backToTop();
    });
    $('#back-to-top').on('click', function (e) {
      e.preventDefault();
      $('html,body').animate({
        scrollTop: 0
      }, 700);
    });
  }
}

function scroll_to_anchor(anchor_id){
  var tag = $("#"+anchor_id+"");
  var distance = (tag.offset().top-145);
  if (window.location.pathname.includes('/products') || window.location.pathname.includes('/t/')){
    distance = 10;
  }  
  $('html,body').animate({
    scrollTop: (distance)
  },'slow');
}

function addProductToCart(product_id, temp_id){
  var product_id_t = product_id
  var ext_url = "";
  if (temp_id != null){
    product_id_t = temp_id;
    ext_url = "?variant_id_t="+parseInt(product_id).toString();
  }else if(temp_id == "variant"){
    ext_url = "?variant_id="+parseInt(product_id).toString();
  }
  $('#loader'+product_id_t).removeClass("hidden");
  //$('#product-main'+product_id).addClass("hidden");
  $.ajax({
    type: "POST",
    url: "/orders/populate_ajax"+ext_url,
    data:  $('#product_form'+product_id).serialize(),
    success: function(msg){
     Spree.fetch_cart();
       //$('#product-main'+product_id).removeClass("hidden");
       $('#loader'+product_id_t).addClass("hidden");

       $('#product-'+product_id+'-variants').addClass('fadeOutLeft');
       $('#product-'+product_id+'-variants').addClass('hidden');
       $('.product-'+product_id+'-action').removeClass('fadeOutLeft')
       $('.product-'+product_id+'-action').show();


       alertify.success("Se ha agregado el producto al carro.");
     },
     error: function(evt, xhr, status, error) {
       if(evt.status == 500){
        text= ["Ha ocurrido un error inesperado, revise su conexi\u00F3n a internet."];  
      }
      else{
        text = JSON.parse(evt.responseText).error;
      }
       //$('#product-main'+product_id).removeClass("hidden");
       $('#loader'+product_id_t).addClass("hidden");
       alertify.error(text[0]);

     }
   });
}

$(".add-to-cart-service").click(function(){
  $('.loader-page').fadeIn();
  $.post('/orders/populate_service.js', {'variant_id': $(this).data('id'), 'quantity': 1});
});

function addProductToComparator(product_id){
  $('#loader'+product_id).removeClass("hidden");
  $.ajax({
    type: "POST",
    url: "/comparator/add_product",
    data: "variant_id="+product_id,
    success: function(msg){
      $('#loader'+product_id).addClass("hidden");
      alertify.success("Se ha agregado el producto satisfactoriamente.");
    },
    error: function(xhr, status, error) {
      $('#loader'+product_id).addClass("hidden");
      alertify.error("Puede comparar como m\u00E1ximo 4 productos.");
    }
  });
}
function mobile_nav_overlay(overlay){
  if ($("#wrapper").hasClass("toggled")){
    close_nav_overlay(overlay)
  }else{
    open_nav_overlay(overlay)
  }
}
function close_nav_overlay(overlay){
  overlay.hide();
  $("#sidebar-wrapper").slideToggle('slow');
  $(".hamburger").removeClass("is-open");
  $(".hamburger").addClass("is-closed");
  $("#wrapper").removeClass("toggled");      
}
function open_nav_overlay(overlay){
  overlay.show();
  $("#sidebar-wrapper").slideToggle('slow');
  $(".hamburger").removeClass("is-closed");
  $(".hamburger").addClass("is-open");
  $("#wrapper").addClass("toggled");      
}

function openNav(id, e){
  //$('#mySidenav').css('top', $('#header').outerHeight());
  if (e) {
    e.preventDefault();
  }

  if ($(window).width() < 440) {
    document.getElementById("mySidenav").style.width = "100%";
  }
  else if($(window).width() > 440 && $(window).width() < 1000){

    document.getElementById("mySidenav").style.width = "80%";

  }else{
    document.getElementById("mySidenav").style.width = "34.166%";

  }
  $(".overlay").show();
}
function closeNav() {
  document.getElementById("mySidenav").style.width = "0";
  $(".overlay").hide();
};  

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = 'https://connect.facebook.net/es_LA/sdk.js#xfbml=1&version=v2.11&appId=1840667506263435';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
// FacebookSDK
// Compatibility with Turbolinks 5
(function($) {
  var fbRoot;

  function saveFacebookRoot() {
    if ($('#fb-root').length) {
      fbRoot = $('#fb-root').detach();
    }
  };

  function restoreFacebookRoot() {
    if (fbRoot != null) {
      if ($('#fb-root').length) {
        $('#fb-root').replaceWith(fbRoot);
      } else {
        $('body').append(fbRoot);
      }
    }

    if (typeof FB !== "undefined" && FB !== null) { // Instance of FacebookSDK
      FB.XFBML.parse();
    }
  };


  // document.addEventListener('turbolinks:request-start', saveFacebookRoot)
  // document.addEventListener('turbolinks:load', restoreFacebookRoot)
  // Desmonta todos los componentes cuando turbolinks termina de cachear, para evitar replicaciones
  // document.addEventListener('turbolinks:before-cache', function () {
  //  ReactRailsUJS.unmountComponents();
  //})
}(jQuery));

function getComunasByRegion(state_selector, comuna_selector, selected_comuna) {
  if($(state_selector).val() != "" && $(state_selector).val() != undefined){
    return $.ajax({
      url: '/comunas/comuna_by_region',
      type: 'get',
      dataType: 'json',
      data: {region_id: $(state_selector).val()},
      success: function(data) {           
        $(comuna_selector).html("");
        $(comuna_selector).append(new Option('', ''));
        for (var i = 0; i < data.length; i++) {
          var option = new Option(data[i][1], data[i][0]);
          if (selected_comuna == data[i][0]) {
            option.selected = true;
          }
          $(comuna_selector).append(option);
        }
        $(comuna_selector).change();
      },
      error: function(hxr) {

      }
    });
  }
}

function fetchCurrentStock(skus) {
  return $.post('/products/fetch_stock', {'tnrs': skus});
}

function homologateBoxHeights(class_name) {
  var heights = []; 
  $(class_name).each(function(){
    heights.push($(this).height());
  });
  var max_height = Math.max.apply(null, heights);
  $(class_name).each(function(){
    $(this).height(max_height);
  }); 
}
