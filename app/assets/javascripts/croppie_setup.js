document.addEventListener('turbo:load', function() {
  var cropperElement = document.getElementById('image-cropper');
  var imageFileInput = document.querySelector('input[type=file]');
  var fileSelected = false;

  if (cropperElement) {
    croppieInstance = new Croppie(cropperElement, {
      viewport: { width: 200, height: 200, type: 'square' },
      boundary: { width: 300, height: 300 }
    });

    imageFileInput.addEventListener('change', function() {
      var file = this.files[0];
      if (file) {
        fileSelected = true;
        var fileType = file.type;
        var matches = fileType.match(/image\/(png|jpeg|jpg)/);

        if (matches === null) {
          this.value = '';
          fileSelected = false;
          displayErrors(['画像はpng, jpeg, jpg形式である必要があります']);
          return;
        }

        var reader = new FileReader();
        reader.onload = function(e) {
          croppieInstance.bind({
            url: e.target.result
          });
        };
        reader.readAsDataURL(file);
      }
    });

    document.querySelector('form').addEventListener('submit', function(e) {
      e.preventDefault();

      if (fileSelected) {
        croppieInstance.result({
          type: 'blob',
          format: 'jpeg',
          quality: 1.0
        }).then(function(blob) {
          var formData = new FormData();
          formData.append('post[image]', blob, 'cropped-image.jpeg');
          submitForm(formData);
        });
      } else {
        submitForm(new FormData(this));
      }
    });
  }

  function submitForm(formData) {
    formData.append('post[name]', document.getElementById('post_name').value);
    formData.append('post[body]', document.getElementById('post_body').value);
    var tagsElement = document.getElementById('post_tags');
    if (tagsElement) {
      formData.append('post[tags]', tagsElement.value);
    }

    fetch('/posts', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      body: formData
    })
    .then(response => response.json())
    .then(handleResponse)
    .catch(handleError);
  }

  function handleResponse(data) {
    if (data.redirect_url) {
      window.location.href = data.redirect_url;
    } else {
      displayErrors(data.errors);
    }
  }

  function handleError(error) {
    console.error('Error:', error);
  }

  function displayErrors(errors) {
    const existingErrors = document.querySelector('.flash-message');
    if (existingErrors) {
      existingErrors.remove();
    }

    const flashMessageContainer = document.createElement('div');
    flashMessageContainer.classList.add('flash-message', 'danger');
    errors.forEach((error) => {
      const messageElement = document.createElement('div');
      messageElement.textContent = error;
      flashMessageContainer.appendChild(messageElement);
    });
    const headerElement = document.querySelector('h1');
    headerElement.parentNode.insertBefore(flashMessageContainer, headerElement.nextSibling);
  }
});
