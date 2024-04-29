document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('q_name_cont');

  searchInput.addEventListener('keyup', function() {
    const input = searchInput.value;
    if (input.length > 0) {
      fetch(`/characters/auto_complete?query=${encodeURIComponent(input)}`, {
        method: 'GET'
      })
      .then(response => response.json())
      .then(data => {
        updateDropdown(data);
      })
    }
  });

  function updateDropdown(data) {
    const dropdown = document.getElementById('dropdown');
    dropdown.innerHTML = '';
    data.forEach(item => {
      const option = document.createElement('div');
      option.textContent = item.name;
      option.classList.add('dropdown-item');
      dropdown.appendChild(option);
    });
    if (data.length > 0) {
      dropdown.classList.add('show');
    } else {
      dropdown.classList.remove('show');
    }
  }
});

document.addEventListener('turbo:load', function() {
  const searchInput = document.getElementById('q_name_cont');
  const dropdown = document.getElementById('dropdown');
  const bell = document.getElementById('notification-bell');

  searchInput.addEventListener('click', function() {
    dropdown.style.display = 'block';
  });
  
  searchInput.addEventListener('keyup', function() {
    dropdown.style.display = 'block';
  });

  document.addEventListener('click', function(event) {
    if (!searchInput.contains(event.target) && !dropdown.contains(event.target) && !bell.contains(event.target)) {
      dropdown.style.display = 'none';
    }
  });
});

document.addEventListener('turbo:load', function() {
  document.addEventListener('click', function(event) {
    const item = event.target.closest('.dropdown-item');
    if (item) {
      const searchInput = document.querySelector('.character-search-field');
      if (searchInput) {
        searchInput.value = item.textContent.trim();
        const form = document.querySelector('form');
        form.submit();
      }
    }
  });
});