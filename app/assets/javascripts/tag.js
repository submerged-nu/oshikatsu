$(document).ready(function() {
  $('#tags').on('cocoon:after-insert', function(e, insertedItem) {
    let tagCount = $(".nested-fields").length + 1;
    let tagLabel = "タグ" + tagCount;
    insertedItem.find("label").first().text(tagLabel);

    if (tagCount >= 5) {
      $("#add-tag-link").hide();
    }
  });

  $('#tags').on('cocoon:after-remove', function(e, removedItem) {
    if ($(".nested-fields").length < 5) {
      $("#add-tag-link").show();
    }
  });
});
