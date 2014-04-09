$(function() {

    $('#comic_mindlog_id').selectize({
   	create: false,
    maxOptions: 1,
    openOnFocus: false,
    valueField: 'id',
    labelField: 'title',
    searchField: 'title',

    load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
            url: '/mindlogs/autocomplete?query=' + encodeURIComponent(query),
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