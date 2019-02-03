App.comments = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if $("#comments").val()?
      $("#comments .comment-cable:first").prepend(data)
    else
      $(".marg-bottom .comment-heading").val("Previous Comments")
      $("#new-comments").prepend(data)
    
    # Called when there's incoming data on the websocket for this channel
