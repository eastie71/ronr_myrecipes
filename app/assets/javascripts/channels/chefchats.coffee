App.chefchats = App.cable.subscriptions.create "ChefchatsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#messages').prepend data['message']
    $('#message_content').val('')
    return
    # Called when there's incoming data on the websocket for this channel
