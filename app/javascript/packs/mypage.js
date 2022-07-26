// タブの切り替え
$(document).on('turbolinks:load', function() {
  $(function() {
    $('.tab').click(function() {
      $('.tab-active').removeClass('tab-active');
      $(this).addClass('tab-active');
      $('.box-show').removeClass('box-show');
      const index = $(this).index();
      $('.tabbox').eq(index).addClass('box-show');
    });
  });
});

// ページネーション
$(".js-filter-items").pagination({
  itemElement : '> tr',
  displayItemCount: 10,
  prevNextPageBtnMode: true,
  firstEndPageBtnMode: true,
  onePageOnlyDisplay: true,
  paginationClassName: 'pagination',
  setPaginationMode: 'after',
})

// プルダウンによる絞り込み
$(".js-filter-form").on("change", function(){
  var selected = [];
  $(".js-filter-form :selected").each(function(){
    selected.push($(this).val());
  });
  // console.log(selected);

  $(".js-filter-items tr").each(function(){
    var id = $(this).data("id");
    var is_exist = $.inArray( String(id), selected );
    if (selected[0] == 'all'){
      is_exist = 0
    }
    // console.log(id);
    // console.log(selected);
    // console.log(is_exist);
    if (is_exist != -1) {
      $(this).removeClass("hidden");
      $(this).css("display",""); // paginationがつけたdisplay要素を削除する
    } else {
      $(this).addClass("hidden");
      $(this).css("display",""); // paginationがつけたdisplay要素を削除する
    }
  });

  // ページネーションを作り直す
  $('.pagination').remove();
  $(".js-filter-items").pagination({
    itemElement : '> tr:not(.hidden)',
    displayItemCount: 10,
    prevNextPageBtnMode: true,
    firstEndPageBtnMode: true,
    onePageOnlyDisplay: true,
    paginationClassName: 'pagination',
    setPaginationMode: 'after',
  })
});