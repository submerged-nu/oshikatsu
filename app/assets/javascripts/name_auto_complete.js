document.addEventListener('DOMContentLoaded', function() {
  const nameInput = document.getElementById('post_name');

  nameInput.addEventListener('keyup', function() {
    const input = nameInput.value;
    if (input.length > 0) {
      fetch(`/characters/auto_complete?query=${encodeURIComponent(input)}`, {
        method: 'GET'
      })
      .then(response => response.json())
      .then(data => {
        updateDropdown(data);
      })
    } else {
      document.getElementById('name-dropdown').style.display = 'none';
    }
  });

  function updateDropdown(data) {
    const dropdown = document.getElementById('name-dropdown');
    dropdown.innerHTML = '';
    data.forEach(item => {
      const option = document.createElement('div');
      option.textContent = item.name;
      option.classList.add('name-dropdown-item');
      dropdown.appendChild(option);
    });
    dropdown.style.display = data.length > 0 ? 'block' : 'none';
  }
});

document.addEventListener('turbo:load', function() {
  const dropdown = document.getElementById('name-dropdown');

  document.addEventListener('click', function(event) {
    dropdown.style.display = 'none';
  });
});
