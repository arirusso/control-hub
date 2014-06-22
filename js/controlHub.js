ControlHub = function(network, options) {
  options = options || {};
  this.debug = options.debug || false;
  this.webSocket;
  this.network = network;
  this.onClose = options.onClose;
  this.initialize();
}

// Convert the raw websocket JSON message
ControlHub.eventToControllerMessage = function(evt) {
  var msg = JSON.parse(evt.data);
  // format values
  for (var i in msg) {
    if (i === 'timestamp') {
      var timestamp = Number(msg.timestamp);
      msg.time = new Date(timestamp);
    } else {
      msg[i].index = Number(msg[i].index);
      msg[i].value = parseFloat(msg[i].value);
    }
  }
  return msg;
}

// initialize the socket
ControlHub.prototype.initialize = function() {
  var address = "ws://" + this.network.host + ":" + this.network.port + "/echo";
  if ("WebSocket" in window)
  {
    this.webSocket = new WebSocket(address);
    this.webSocket.onopen = function() {
      console.log("control hub ready")  
    };
    var controller = this;
    this.webSocket.onclose = function() {  
      console.log("control hub closed"); 
      if (controller.onClose !== undefined && controller.onClose !== null) {
        controller.onClose();
      }
    };
  } else {
    console.log("websocket not supoorted");
  }
}

// Disable the controller
ControlHub.prototype.disable = function() {
  this.webSocket.onmessage = function(event) {};
  return false;
}

// Handle a single event
ControlHub.prototype.handleEvent = function(event, callback) {
  var message = ControlHub.eventToControllerMessage(event);
  if (this.debug) {
    console.log("message received: ");
    console.log(message);
  }
  callback(message);
  return message;
}

// Initialize controller events
ControlHub.prototype.onMessage = function(callback) {
  var controller = this;
  this.webSocket.onmessage = function(event) { 
    controller.handleEvent(event, callback); 
  };
  return true;
}