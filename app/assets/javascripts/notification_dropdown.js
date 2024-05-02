function setupNotifications() {
  const bell = document.getElementById('notification-bell');
  const notificationDropdown = document.getElementById('notification-dropdown');
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  if (bell && notificationDropdown) {
    bell.addEventListener('click', function(event) {
      event.stopPropagation();
      displayNotifications().then(() => {
        markNotificationsAsRead(csrfToken);
      });
      notificationDropdown.style.display = notificationDropdown.style.display === 'block' ? 'none' : 'block';
    });

    document.addEventListener('click', function(event) {
      if (!notificationDropdown.contains(event.target) && !bell.contains(event.target)) {
        notificationDropdown.style.display = 'none';
      }
    });
  }

  function displayNotifications() {
    return fetch(`/notifications`, { method: 'GET' })
      .then(response => response.json())
      .then(data => {
        updateNotificationDropdown(data);
        return data;
      });
  }

  function updateNotificationDropdown(data) {
    notificationDropdown.innerHTML = '';

    if (data.length === 0) {
      const noNotificationItem = document.createElement('div');
      noNotificationItem.textContent = '新しい通知はありません。';
      noNotificationItem.classList.add('notification-item');
      notificationDropdown.appendChild(noNotificationItem);
    } else {
      data.forEach(notification => {
        const notificationItem = document.createElement('div');
        notificationItem.textContent = notification.message;
        notificationItem.classList.add('notification-item');
        notificationDropdown.appendChild(notificationItem);
      });
    }
  }

  function markNotificationsAsRead(csrfToken) {
      fetch('/notifications/mark_as_read', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({})
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            const notificationIndicator = document.querySelector('.notification-indicator');
            notificationIndicator.style.display = 'none';
            //DOMContentLoaded時点でindicatorが存在する必要があるのでindicatorを存在させるか判定するのではなく
            //@unread_notificationsが存在する場合はblock,ない場合はnoneにして切り替えれるようにすべき
            //これが終われば通知は終わり
          }
        })
        .catch(error => console.error('Error marking notifications as read:', error));
  }
};

document.addEventListener('DOMContentLoaded', setupNotifications);
document.addEventListener('turbolinks:load', setupNotifications);
