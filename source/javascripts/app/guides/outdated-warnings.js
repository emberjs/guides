// Expects v1.10.0 (e.g. vMAJOR.MINOR.PATCH)
function parseVersion(version) {
  var match = version.match(/^v(\d+)\.(\d+)\.(\d+)$/);
  if (match) {
    return {
      major: match[1],
      minor: match[2],
      patch: match[3]
    };
  }
}

GUIDE_VERSIONS.onReady(function(versions) {
  var releases = $.grep(versions.available, function(v) {
    return v.type === 'release';
  });

  var releaseVersions = $.map(releases, function(v) {
    return v.version;
  });

  if (!$.inArray(versions.current, releaseVersions)) { return; }

  releaseVersions.sort(function(a, b) {
    a = parseVersion(a);
    b = parseVersion(b);

    if (a.major !== b.major) { return a.major - b.major; }
    if (a.minor !== b.minor) { return a.minor - b.minor; }
    return a.patch - b.patch;
  });

  if (versions.current !== releaseVersions[0]) {
    // Older version
    $('.chapter').prepend('<div class="old-version-warning">This is an old version of the guides.</div>');
  }

});