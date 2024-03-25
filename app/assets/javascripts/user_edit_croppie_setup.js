var userImage = document.getElementById('image');
var userImageInput = document.getElementById('user-image-field');
var fileDropZone = document.querySelector('.file-drop-zone');
var cropper;
var imageLoaded = false;

if (userImage && userImageInput) {
  function initializeCropper() {
    userImageInput.addEventListener('change', function (e) {
      var files = e.target.files;
      if (files && files.length > 0) {
        var reader = new FileReader();
        reader.onload = function (e) {
          userImage.src = e.target.result;
          userImage.style.display = 'block';
          if (cropper) {
            cropper.destroy();
          }
          cropper = new Cropper(userImage, {
            aspectRatio: 1 / 1
          });
          imageLoaded = true;
        };
        reader.readAsDataURL(files[0]);
        fileDropZone.textContent = files[0].name;
      }
    });
  }

  document.addEventListener('turbo:load', initializeCropper);
  document.addEventListener('turbo:visit', initializeCropper);
  document.addEventListener('turbo:render', initializeCropper);
  document.addEventListener('DOMContentLoaded', initializeCropper);

  function submitCroppedImage(e) {
    e.preventDefault();

    var userId = e.target.getAttribute('data-user-id');
    var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
    var formData = new FormData(e.target);
    var userName = document.getElementById('user-name').value;
    formData.append('user[name]', userName);

    if (cropper) {
      cropper.getCroppedCanvas().toBlob(function (blob) {
        formData.append('user[image]', blob, 'cropped-image.jpeg');
        sendFormData(userId, csrfToken, formData);
      }, 'image/jpeg', 1.0);
    }
  }

  function sendFormData(userId, csrfToken, formData) {
    var actionUrl = `http://localhost:3000/users/${userId}`;
    console.log(actionUrl)
    fetch(`http://localhost:3000/users/2`, {
        method: 'PATCH',
        headers: {
            'X-CSRF-Token': csrfToken
        },
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.redirect_url) {
            window.location.href = data.redirect_url;
        } else {
            console.error('Form submission error');
        }
    })
    .catch((error) => {
        console.error('Error:', error);
    });
  }

  document.querySelector('form').addEventListener('submit', submitCroppedImage);
}
