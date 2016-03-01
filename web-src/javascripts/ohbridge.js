var Ohbridge;
(function() {
  var topicRex = /smarthome\/items\/([^\/]*)\/state/;

  var source = new EventSource('/rest/events?topics=smarthome/items/*/state');

  var subscriptions = {};

  source.addEventListener("message", function(eventPayload) {
    var event = JSON.parse(eventPayload.data);
    if (event.type === "ItemStateChangedEvent") {
      var match = topicRex.exec(event.topic);
      if (!match) { return; }
      var item = match[1];
      var payload = JSON.parse(event.payload);
      var newValue = payload.value;
      console.log("Received update event for "+item+". State changed to "+newValue)
      if (Dashing.widgets[item]) {
        Dashing.widgets[item].forEach(function(widget) {
          widget.receiveData({state: newValue});
        });
      }
      if (subscriptions[item]) {
        subscriptions[item].forEach(function(callback) {
          callback.call(window, newValue);
        });
      }
    }
  });

  Ohbridge = {
    queryState: function(itemName, callback) {
      $.get('/rest/items/' + itemName + '/state', {}, callback);
    },
    queryGroup: function(groupName, callback) {
      $.get('/rest/items/' + groupName, {}, callback);
    },
    setState: function(itemName, state) {
      $.ajax({
        url: '/rest/items/' + itemName,
        contentType: 'text/plain',
        data: state,
        type: 'POST'
      });
    },
    subscribe: function(itemName, callback) {
      if (!subscriptions[itemName]) {
        subscriptions[itemName] = [];
      }
      subscriptions[itemName].push(callback);
    }
  }
})();
