document.addEventListener('DOMContentLoaded', () => {
  const userId = document.body.getAttribute('data-user-id');
  if (userId) {
    App.notifications = App.cable.subscriptions.create({channel: "NotificationsChannel", user_id: userId}, {
      connected() {
      },

      disconnected() {
      },

      received(data) {
        const notificationBell = document.getElementById('notification-bell');
        let indicator = notificationBell.querySelector('.notification-indicator');

        indicator = document.createElement('span');
        indicator.className = 'notification-indicator';
        notificationBell.appendChild(indicator);
        indicator.style.display = 'block';
      }
    });
  }
});
