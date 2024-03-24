var postImage = document.getElementById('image');
var postImageInput = document.getElementById('post-image-field');
var fileDropZone = document.querySelector('.file-drop-zone');
var cropper;
var imageLoaded = false;

if(postImage){
  console.log('postImageは存在')
}

if (postImageInput){
  console.log('postImageInputは存在')
}


if (postImage && postImageInput) {
  console.log('条件式通った')
  function initializeCropper() {
    postImageInput.addEventListener('change', function (e) {
      console.log('変更を検知')
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
    if (imageLoaded) {
      var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

      cropper.getCroppedCanvas().toBlob(function (blob) {
        var formData = new FormData(e.target);
        var postName = document.querySelector('.post_name').value;
        var postBody = document.querySelector('.post_body').value;
        var postTags = document.querySelector('.post_tags').value;
        formData.append('post[image]', blob, 'cropped-image.jpeg');
        formData.append('post[name]', postName);
        formData.append('post[body]', postBody);
        formData.append('post[tags]', postTags);

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
  }

  document.querySelector('form').addEventListener('submit', submitCroppedImage);
}
