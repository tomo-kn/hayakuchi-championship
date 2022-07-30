// ページネーション
$('.pagination').remove();
$(".js-filter-items").pagination({
  itemElement : '> tr',
  displayItemCount: 10,
  prevNextPageBtnMode: true,
  firstEndPageBtnMode: true,
  onePageOnlyDisplay: true,
  paginationClassName: 'pagination',
  setPaginationMode: 'after',
})


