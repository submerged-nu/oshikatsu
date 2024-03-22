var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

document.addEventListener('turbo:load', function() {
  var cropperElement = document.getElementById('image-cropper');
  var userEditElement = document.getElementById('post-image-field')

  if (cropperElement && userEditElement) {
     var croppieInstance = new Croppie(cropperElement, {
      viewport: { width: 250, height: 250, type: 'square' },
      boundary: { width: 300, height: 300 }
    });

    document.querySelector('input[type=file]').addEventListener('change', function() {
      console.log('ファイルフィールドの変化を検知')
      var reader = new FileReader();
      reader.onload = function(e) {
        croppieInstance.bind({
          url: e.target.result  
        });
        console.log(e.target.result)
      };
      reader.readAsDataURL(this.files[0]);
    });

    document.querySelector('form').addEventListener('submit', function(e) {
      e.preventDefault();

      croppieInstance.result({
        type: 'blob',
        format: 'jpeg',
        quality: 1.0
      }).then(function(blob) {
        var formData = new FormData();
        formData.append('post[image]', blob, 'cropped-image.jpeg');
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
      });
    });
  }
});