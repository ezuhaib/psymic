var mindlogs = new Bloodhound({
  datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.title); },
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  remote: "/mindlogs/autocomplete?query=%QUERY"
});

var tags = new Bloodhound({
  datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  remote: "/mindlogs/autocomplete_tags?query=%QUERY"
});

$(document).on('ready page:load', function(){
	mindlogs.initialize();
	tags.initialize();

	$("#mindlog_search").typeahead({
		minLength: 2,
		highlight: true,
		autoselect: true
	},{
		name: "mindlog",
		displayKey: "title",
		source: mindlogs.ttAdapter()
	},{
		name: "tags",
		displayKey: "name",
		source: tags.ttAdapter(),
	});
})