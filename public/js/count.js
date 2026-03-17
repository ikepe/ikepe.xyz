document.getElementById('text').addEventListener('input', function() {
  var text = this.value;

  // 文字数（改行を含まない）
  var countWithoutNewlines = text.replace(/\r?\n|\r/g, '').length;

  // 文字数（改行を含む）
  var countWithNewlines = text.length;

  document.getElementById('withoutNewlines').innerText = countWithoutNewlines;
  document.getElementById('withNewlines').innerText = countWithNewlines;
});
