(function() {
  var render, select, link;
  $('#search-input').focus();
  render = function(term, data, type) {
    return term;
  };
  select = function(term, data, type) {
    $('#search-input').val(term);
    $('ul#soulmate').hide();
    return window.location = data.permalink;
  };
  
  $('#search-input').soulmate({
    url: 'http://0.0.0.0:3000/autocomplete/search',
    types: ['movies','shows'],
    renderCallback: render,
    selectCallback: select,
    minQueryLength: 2,
    maxResults: 12
  });
}).call(this);
