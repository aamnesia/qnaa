$(document).on 'DOMContentLoaded', () ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
    ,
    received: (data) ->
      if data.comment.user_id != gon.user_id
        commentHtml = HandlebarsTemplates['comment'](data)
        resourceType = data.comment.commentable_type
        divComment =
          if resourceType == 'Question'
          then $('.question_comments')
          else $('#answer_' + data.comment.commentable_id).find('.answer_comments')
        divComment.append(commentHtml)
  });
