document.addEventListener('DOMContentLoaded', function() {
  const bell = document.getElementById('notification-bell');
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  
  bell.addEventListener('click', function(event) {
    event.stopPropagation();
    displayNotifications().then(() => {
      markNotificationsAsRead(csrfToken);
    })
  });

  function displayNotifications(){
    return fetch(`/notifications`, {
      method: 'GET'
    })
    .then(response => response.json())
    .then(data => {
      notificationDropdown(data);
    });
  }
  
  function notificationDropdown(data) {
    const dropdown = document.getElementById('notification-dropdown');

    dropdown.innerHTML = '';
  
    if (!data.length) {
      dropdown.innerHTML = '<div class="notification-item">新しい通知はありません。</div>';
      return;
    }
  
    data.forEach(notification => {
      const element = document.createElement('div');
      element.classList.add('notification-item');
      element.textContent = notification.message;
      dropdown.appendChild(element);
    });
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
