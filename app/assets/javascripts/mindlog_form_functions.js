$(function() {
    $('#mindlog_topic_list').selectize({
    create: true,
    hideSelected: true,
    openOnFocus: false,
    maxOptions: 3,
    delimiter: ',',
    valueField: 'name',
    labelField: 'name',
    searchField: 'name',

    load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
            url: '/mindlogs/tags?q=' + encodeURIComponent(query),
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