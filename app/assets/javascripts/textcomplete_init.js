$(document).bind('DOMSubtreeModified', function(){
	$('textarea').textcomplete([{
  	match:    /(^|\s)@(\w*)$/,
	search: function (term, callback) {
	  $.getJSON('/users/autocomplete', { q: term })
	    .done(function (resp) { callback(resp); })
	    .fail(function ()     { callback([]);   });
	},
	replace: function (value) {
	  return '$1@' + value + ' ';
	}
  }])
})