window.GUIDE_VERSIONS.onReady(function(versions) {
  if ($.inArray(versions.current, versions.available) === -1) { return; }

  if (versions.current !== versions.available[0]) {
    var latestUrl = versions.urlFor(versions.latest);
    // Viewing older version
    var oldVersionWarning = [
      '<div class="old-version-warning">',
        '<i class="icon-attention-circled"></i>',
        '<strong>Old Guides - </strong>',
        'You are viewing the guides for Ember ' + versions.current + '.',
        '<a href="' + latestUrl + '" class="btn">',
          'VIEW ' + versions.latest,
        '</a>',
      '</div>'
    ].join('');

    $('.chapter').prepend(oldVersionWarning);
  }
});
