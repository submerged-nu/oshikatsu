App.cable.subscriptions.create("NotificationsChannel", {
  connected() {
  },

  disconnected() {
  },

  received: function(data) {
    if (data.unread_count > 0) {
      document.getElementById('notification-indicator').style.display = 'block';
    } else {
      document.getElementById('notification-indicator').style.display = 'none';
    }
  }
});