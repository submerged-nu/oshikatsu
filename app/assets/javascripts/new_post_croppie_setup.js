function initializeCropper() {
  var dropArea = document.getElementById('drop-area');
  var image = document.getElementById('image');
  var input = document.getElementById('post-image-field');
  var cropper;
  var imageLoaded = false;

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
    if (!imageLoaded) { // 画像がまだロードされていない場合のみ処理を行う
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
      if (!imageLoaded) { // 画像がまだロードされていない場合のみ処理を行う
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
}

document.addEventListener('turbo:load', initializeCropper);
document.addEventListener('DOMContentLoaded', initializeCropper);
