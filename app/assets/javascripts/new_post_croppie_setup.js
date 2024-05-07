var postImage = document.getElementById('image');
var postImageInput = document.getElementById('post-image-field');
var fileDropZone = document.querySelector('.file-drop-zone');
var cropper;
var imageLoaded = false;

if (postImage && postImageInput) {
  function initializeCropper() {
    postImageInput.addEventListener('change', function (e) {
      var files = e.target.files;
      var done = function (url) {
        postImage.src = url;
        postImage.style.display = 'block';
        if (cropper) {
          cropper.destroy();
        }
        cropper = new Cropper(postImage, {
          aspectRatio: 1 / 1
        });
        imageLoaded = true;
      };

      if (files && files.length > 0) {
        var reader = new FileReader();
        reader.onload = function (e) {
          done(e.target.result);
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
    var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    cropper.getCroppedCanvas().toBlob(function (blob) {
        var formData = new FormData(e.target);
        var postName = document.querySelector('#post_name').value;
        var postBody = document.querySelector('#post_body').value;
        var firstTag = document.querySelector('#post_tag1').value;
        var tagInputs = document.querySelectorAll('.nested-fields input[type="text"]');
        tagInputs.forEach((input, index) => {
          formData.append(`post[tag${index + 2}]`, input.value);
        });
        formData.append('post[image]', blob, 'cropped-image.jpeg');
        formData.append('post[name]', postName);
        formData.append('post[body]', postBody);
        formData.append('post[tag1]', firstTag);

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
    }, 'image/jpeg', 1.0);
}

  document.querySelector('form').addEventListener('submit', submitCroppedImage);
}
