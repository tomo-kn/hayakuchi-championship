// ページネーション
$('.pagination').remove();
$('.pagiWrapper').remove();
$(".js-filter-items").pagination({
  itemElement : '> tr',
  displayItemCount: 10,
  firstEndPageBtnMode: true,
  paginationClassName: 'pagination',
});
// paginationクラスをpagiWrapperクラスで囲む
$(function() {
  $(".pagination").wrap("<div class='pagiWrapper'></div>");
});
