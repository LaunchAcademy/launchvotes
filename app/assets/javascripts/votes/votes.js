$(function(){
  updateRibbonLinks();
  $('.ribbon').on('click', function(event) {
    event.preventDefault();
    event.stopPropagation();
    var $this = $(this);
    var $spanTag = $this.find('span');
    var $aTag = $this.find('a');
    var currentText = $spanTag.text();
    var url = $aTag.attr('href');
    var method, newText;

    if (currentText === 'Vote') {
      method = 'POST';
      newText = 'Voted!';
    } else {
      method = 'DELETE';
      newText = 'Vote';
    }

    $.ajax({
      url: url,
      method: method,
      dataType: 'json'
    })
    .done(function(vote) {
      $spanTag.toggleClass('voted');
      $spanTag.text(newText);
      $aTag.attr('href', newRibbonUrl(url, vote.id));
    });
  });
});

function updateRibbonLinks() {
  var originalHref, $element;
  $('.ribbon a').each(function(index, element) {
    $element = $(element);
    originalHref = $element.attr('href');
    $element.attr('href', '/api/v1' + originalHref);
  });
}

function newRibbonUrl(url, voteId) {
  var splitUrl = url.split('/');
  if (splitUrl.length === 6) {
    splitUrl.push(voteId);
  } else {
    splitUrl.pop();
  }
  return splitUrl.join('/');
}
