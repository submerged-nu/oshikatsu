document.addEventListener('DOMContentLoaded', function() {
  const bell = document.getElementById('notification-bell');
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  bell.addEventListener('click', function(event) {
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
        });
    }
    event.stopPropagation();
  });
});
