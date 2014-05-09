$(document).on('ready page:load', function() {

    $('#channel_id').selectize({
   	create: false,
    maxOptions: 1,
    openOnFocus: false,
    valueField: 'id',
    labelField: 'title',
    searchField: 'title',

    load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
            url: '/channels/autocomplete?query=' + encodeURIComponent(query),
            type: 'GET',
            error: function() {
                callback();
            },
            success: function(res) {
                callback(res);
            }
        });
    }
});

});