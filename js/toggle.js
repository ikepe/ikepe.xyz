// 過去の所属のヘッダーがクリックされた時のイベントハンドラを設定
window.addEventListener('DOMContentLoaded', (event) => {
  document.getElementById('past-affiliation-header').addEventListener('click', function() {
    var content = document.getElementById('past-affiliation-content');
    if (content.style.display === 'none' || content.style.display === '') {
      content.style.display = 'block'; // コンテンツを表示
    } else {
      content.style.display = 'none'; // コンテンツを非表示
    }
  });
});
