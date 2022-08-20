$(document).on('turbolinks:load', function(){
  $('.question').on('ajax:success', function(e) {
    var rating = e.detail[0]['rating'];
    $('.question .vote .rating').html('<p>' + rating + '</p>')
  });

  $('.answers').on('ajax:success', function(e) {
    var object = e.detail[0];
    var rating = e.detail[0]['rating'];
    var resourceId = object['id']
    $('#answer_' + resourceId + ' .vote .rating').html('<p>' + rating + '</p>')
  })
});
