$(document).ready(function() {
  $('#tags').on('cocoon:after-insert', function(e, insertedItem) {
    let tagCount = $(".nested-fields").length;
    let tagLabel = "タグ" + tagCount; // 例: "タグ1"
    insertedItem.find("label").first().text(tagLabel);

    // タグが5個に達したら追加ボタンを非表示
    if (tagCount >= 5) {
      $("#add-tag-link").hide();
    }
  });

  $('#tags').on('cocoon:after-remove', function(e, removedItem) {
    // タグが削除されたら、追加ボタンを再表示（もし隠れていれば）
    if ($(".nested-fields").length < 5) {
      $("#add-tag-link").show();
    }
  });
});
