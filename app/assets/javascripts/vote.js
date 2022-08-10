// $(document).on('turbolinks:load', function(){
//         $('.vote').on('ajax:success', function(e) {
//             let rating = e.detail[0]['rating'],
//                 resourceName = e.detail[0]['resourceName'],
//                 resourceId = e.detail[0]['resourceId'];
//
//             $('#' + resourceName + '_' + resourceId + ' .vote .rating').html(rating)
//         })
// });
$(document).on('turbolinks:load', function(){
  $('.question').on('ajax:success', function(e) {
    var object = e.detail[0];
    rating('.question', object)
  });

  $('.answers').on('ajax:success', function(e) {
    var object = e.detail[0];
    var answer = $('#answer_' + object['id']);
    rating(answer, object)
  })
});

function rating(resource, object) {
  $(resource).find('.rating').html('<p>' + object['rating'] + '</p>')
}
