document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('character-search-field');
  if (searchInput) {
    console.log('検索フィールドが見つかった')
  } else {
    console.log('検索フィールドが見つからない')
  }

  searchInput.addEventListener('keyup', function() {
    const input = searchInput.value;

    if (input.length > 1) {
      fetch(`/characters/search?query=${encodeURIComponent(input)}`, {
        method: 'GET'
      })
      .then(response => response.json())
      .then(data => {
        updateDropdown(data);
      })
      .catch(error => console.error('Error:', error));
    }
  });

  function updateDropdown(data) {
    const dropdown = document.getElementById('dropdown');
    dropdown.innerHTML = '';

    data.forEach(item => {
      const option = document.createElement('div');
      option.textContent = item.name;
      dropdown.appendChild(option);
    });
  }
});