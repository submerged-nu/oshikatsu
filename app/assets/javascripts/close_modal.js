document.addEventListener('click', function(event) {
  if (event.target.matches('.modal-overlay')) {
    event.target.remove();
  } else {
    const modalOverlay = event.target.closest('.modal-overlay');
    if (modalOverlay && !modalOverlay.contains(event.target)) {
      modalOverlay.remove();
    }
  }
});
