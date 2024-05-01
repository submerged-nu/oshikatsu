document.addEventListener('DOMContentLoaded', function() {
  const bell = document.getElementById('notification-bell');
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const notificationsDropdown = document.querySelector('.notifications-dropdown');
  
  bell.addEventListener('click', function(event) {
    event.stopPropagation();
    displayNotifications(data);
    markNotificationsAsRead(csrfToken);
  });

  function displayNotifications(notifications) {
    fetch(`/notifications`, {
      method: 'GET'
    })
    .then(response => response.json())
    .then(data => {
      console.log(data)
      notificationDropdown(data);
    });
  }
  
  function notificationDropdown(data) {
    const notificationDropdown = document.getElementById('notification-dropdown');
    data.forEach(item => {
      const option = document.createElement('div');
      option.textContent = item.name;
      option.classList.add('notification-dropdown-item');
      notificationDropdown.appendChild(option);
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
