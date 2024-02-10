document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll('.post').forEach(function(element) {
    element.addEventListener('click', function() {
      var postId = this.getAttribute('data-post-id'); // 投稿のIDをdata属性から取得
      fetch(`/posts/${postId}`) // Ajaxリクエスト
        .then(response => response.text())
        .then(html => {
          document.querySelector('#postModal .modal-body').innerHTML = html; // モーダルの内容を更新
          $('#postModal').modal('show'); // モーダルを表示
        });
    });
  });
});
