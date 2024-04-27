App.cable.subscriptions.create("NotificationsChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    alert(data.message);  
  }
});