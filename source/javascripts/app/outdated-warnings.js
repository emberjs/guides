window.GUIDE_VERSIONS.onReady(function(versions) {
  if ($.inArray(versions.current, versions.available) === -1) { return; }

  if (versions.current !== versions.available[0]) {
    $('.old-version-warning .latest-version').text(versions.latest);
  }
});
