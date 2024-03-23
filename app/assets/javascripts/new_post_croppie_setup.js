function initializeCropper() {
  var dropArea = document.getElementById('drop-area');
  var image = document.getElementById('image');
  var input = document.getElementById('post-image-field');
  var cropper;
  var imageLoaded = false;

  if(input && image){
    input.addEventListener('change', function (e) {
      var files = e.target.files;
      var done = function (url) {
        image.src = url;
        image.style.display = 'block';
        if (cropper) {
          cropper.destroy();
        }
        cropper = new Cropper(image, {
          aspectRatio: 1 / 1
        });
        deleteFileZone();
        imageLoaded = true;
      };

      if (files && files.length > 0) {
        var reader = new FileReader();
        reader.onload = function (e) {
          done(e.target.result);
        };
        reader.readAsDataURL(files[0]);
      }
    });

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
      dropArea.addEventListener(eventName, preventDefaults, false);
    });

    function preventDefaults(e) {
      e.preventDefault();
      e.stopPropagation();
    }

    dropArea.addEventListener('drop', handleDrop, false);

    function handleDrop(e) {
      if (!imageLoaded) {
        var dt = e.dataTransfer;
        var files = dt.files;
        handleFiles(files);
      }
    }

    function handleFiles(files) {
      files = [...files];
      files.forEach(previewFile);
    }

    function previewFile(file) {
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onloadend = function () {
        if (!imageLoaded) {
          if (cropper) {
            cropper.destroy();
            image.style.display = 'none';
            image.removeAttribute('src');
          }
          image.src = reader.result;
          image.style.display = 'block';
          cropper = new Cropper(image, {
            aspectRatio: 1 / 1
          });
          deleteFileZone();
          imageLoaded = true;
        }
      };
    }

    function deleteFileZone() {
      var fileDropZone = document.querySelector('.file-drop-zone');
      if (fileDropZone) {
        fileDropZone.remove();
      }
    }

    function submitCroppedImage() {
      var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
  
      cropper.getCroppedCanvas().toBlob(function (blob) {
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
      }, 'image/jpeg', 1.0);
    }
    document.querySelector('form').addEventListener('submit', function(e) {
      e.preventDefault();
      if (imageLoaded) {
        submitCroppedImage();
      }
    });
  }
}

document.addEventListener('turbo:load', initializeCropper);
document.addEventListener('DOMContentLoaded', initializeCropper);
