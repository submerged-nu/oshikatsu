App.cable.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to NotificationsChannel");
  },

  disconnected() {
    console.log("Disconnected from NotificationsChannel");
  },

  received(data) {
    console.log(data.message);  
  }
});