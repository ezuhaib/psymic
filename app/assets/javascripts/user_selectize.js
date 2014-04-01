$(function() {

    $('#message_recipient_id').selectize({
   	create: false,
    hideSelected: true,
    openOnFocus: false,
    maxOptions: 1,
    valueField: 'id',
    labelField: 'username',
    searchField: 'username',

    load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
            url: '/users/autocomplete?qb=' + encodeURIComponent(query),
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