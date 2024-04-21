App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  received(data) {
    alert(data.message);
  }
});
