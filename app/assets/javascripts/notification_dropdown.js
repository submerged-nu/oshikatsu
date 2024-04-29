document.addEventListener('DOMContentLoaded', function() {
  const bell = document.getElementById('notification-bell');
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const notificationsDropdown = document.querySelector('.notifications-dropdown');

  bell.addEventListener('click', function(event) {
    event.stopPropagation();

    fetch('/notifications', { method: 'GET' })
      .then(response => response.json())
      .then(data => {
        displayNotifications(data);
        markNotificationsAsRead(csrfToken);
      })
      .catch(error => console.error('Error fetching notifications:', error));
  });

  function displayNotifications(notifications) {
    notificationsDropdown.innerHTML = '';
    notifications.forEach(notification => {
      const item = document.createElement('li');
      item.textContent = `${notification.user_name}があなたの${notification.post_title}に${notification.type}しました。`; // post_nameをpost_titleに修正
      notificationsDropdown.appendChild(item);
    });
    notificationsDropdown.style.display = 'block';
  }

  function markNotificationsAsRead(csrfToken) {
    if (document.querySelector('.notification-indicator').style.display !== 'none') {
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
            document.querySelector('.notification-indicator').style.display = 'none';
          }
        })
        .catch(error => console.error('Error marking notifications as read:', error));
    }
  }
});
