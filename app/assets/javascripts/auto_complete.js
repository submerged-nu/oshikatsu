document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('q_name_cont');

  searchInput.addEventListener('keyup', function() {
    const input = searchInput.value;
    console.log(input)
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

  searchInput.addEventListener('click', function() {
    dropdown.style.display = 'block';
  });
  
  searchInput.addEventListener('keyup', function() {
    dropdown.style.display = 'block';
  });

  document.addEventListener('click', function(event) {
    if (!searchInput.contains(event.target) && !dropdown.contains(event.target)) {
      dropdown.style.display = 'none';
    }
  });
});