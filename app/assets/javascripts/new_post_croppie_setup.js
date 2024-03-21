document.addEventListener('turbo:load', function() {
  var cropperElement = document.getElementById('image-cropper');
  var imageFileInput = document.getElementById('post-image-field');
  var fileSelected = false;

  if (cropperElement && imageFileInput) {
    var croppieInstance = new Croppie(cropperElement, {
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
        reader.readAsDataURL(file);
        reader.onload = function(e) {
          console.log(e.target.result)
          croppieInstance.bind({
            url: e.target.result
          });
        };
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
          var formData = new FormData(this);
          formData.append('post[image]', blob, 'cropped-image.jpeg');
          var postName = document.querySelector('#post_name').value;
          formData.append('post[name]', postName);
          var postBody = document.querySelector('#post_body').value;
          formData.append('post[body]', postBody);
          var postTags = document.querySelector('#post_tags').value;
          formData.append('post[tags]', postTags);
          submitForm(formData);
        });
      } else {
        submitForm(new FormData(this));
      }
    });
  }

  function submitForm(formData) {
    var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

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
});