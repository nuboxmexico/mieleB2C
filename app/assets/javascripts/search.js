$(document).ready(function() {

  $('#mobile-search-btn').click(function(){
    $('#mobile-search-container').slideToggle();
  });
  
  //setup before functions
  var typingTimer;                //timer identifier
  var doneTypingInterval = 1000;  //time in ms, 5 second for example
  const search = document.querySelector('.search-input');
  const search_mobile = document.querySelector('.search-mobile-input');
  const suggestions = document.querySelector('.suggestions');
  
  // estimate when user stop to writing
  //on keyup, start the countdown
  $(search).on('keyup', function () {
    $('#search-button').parent().removeClass('action-btn')
                                .addClass('show-action-btn');
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
  });

  //on keydown, clear the countdown 
  $(search).on('keydown', function () {
    clearTimeout(typingTimer);
  });

  $(search).on('blur', function(){
    if ($(this).val() == '') {
      $('#search-button').parent().removeClass('show-action-btn')
                                         .addClass('action-btn'); 
    }
  });

  $(search_mobile).on('keyup', function () {
    $('#search-button-mobile').parent().removeClass('action-btn')
                                       .addClass('show-action-btn'); 
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneMobileTyping, doneTypingInterval);
  });

  //on keydown, clear the countdown 
  $(search_mobile).on('keydown', function () {
    clearTimeout(typingTimer);
  });

  $(search_mobile).on('blur', function(){
    if ($(this).val() == '') {
      $('#search-button-mobile').parent().removeClass('show-action-btn')
                                         .addClass('action-btn'); 
    }
  });

  //user is "finished typing," do something
  function doneTyping () {
    GetData();
  }
  function doneMobileTyping() {
    GetData();
  }
  //get your data first, and then hook it up.

  function GetData(){
    var products = [];
    var word = "";
    if(this.value === undefined){
      word = search.value;
    }else{
      word = this.value
    }
    var endpoint = '/products.json?utf8=✓&keywords='+ word+ "&taxon=&page=&order_criteria=&brand_any=";
    suggestions.innerHTML = '<li class="li-suggest"><div class="row"><div class="col col-xs-4"></div><div class="col col-xs-5"><div class="showbox-mini loader-box" id= "loader"><div class="loader" align="center"><svg class="circular-mini" viewBox="25 25 50 50"><circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"/></svg></div></div></div><div class="col col-xs-3"></div></div></li>';
    if(word.length >= 3){
      $.get(endpoint, function( data ){
        products.push(...JSON.parse(data["products"]));
        Display(word, products)
      });
    }
    else if (word.length == 0) {
      $('#search-button').parent().removeClass('show-action-btn').addClass('action-btn');
    }
    else {
      products = [];
      suggestions.innerHTML = "";
    }
  }
  // the blob (which is raw data) needs to be converted to readable data.

  function Listen(word, products) {
    return products.filter(product => {
      const regex = new RegExp(word.toLowerCase(), 'gi');
      return product.name.toLowerCase().match(regex) || product.description.toLowerCase().match(regex);
    })
  }

  function Display(word, products){
      if(products.length > 0){
        const match = Listen(word, products);
        const html = match.map(product => {
          const regex = "";
          //const productName = product.name.replace(regex, `<div class="row"><div class="col col-xs-4"><img src=${product.master.images[0].mini_url} class="" alt=""></div><div class="col col-xs-8"><span class="hl"> ${this.value}</span></div></div>`);
          //const stateName = place.state.replace(regex, `<span class="hl"> ${this.value}</span>`);
          if (product.master.images[0] == null){
            image_url = "<%= image_url('noimage/mini.png')%>"; 
          }else{
            image_url = product.master.images[0].mini_url;
          }
          return `
            <li class="li-suggest">
              <a href="/products/${product.slug}">
                <div class="row">
                  <div class="col col-xs-4">
                    <img src=${image_url} class="img-responsive" alt="">
                  </div>
                  <div class="col col-xs-1">
                  </div>
                  <div class="col col-xs-7">
                    <p>
                      ${product.name}
                    </p>
                  </div>
                </div>
              </a>
            </li>
          `;
        }).join('');
        suggestions.innerHTML = html; 
      }else{
        suggestions.innerHTML = '<li class="li-suggest"><div class="row"><p class="no-results-found">No se han encontrado resultados</p></div></li>';
      }
  }

  if (search) {
    search.addEventListener('change', GetData);
  }
  //search.addEventListener('keyup', GetData);
});