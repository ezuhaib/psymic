var channels = new Bloodhound({
  datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.title); },
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  remote: "/channels/autocomplete?query=%QUERY"
});

$(document).on('ready page:load', function(){
	channels.initialize();

	$("#channel_id").typeahead({
		minLength: 2,
		highlight: true,
		autoselect: true
	},{
		name: "channel",
		displayKey: "title",
		source: channels.ttAdapter()
	})
})