GUIDE_VERSIONS.onReady(function(versions) {
  var versionSelect = $(".version-select");
  versionSelect.select2({
    data: $.map(versions.available, function(v) {
      return v.version;
    })
  });

  // Setting val isn't enough, need to trigger change too
  versionSelect.val(versions.current).trigger('change');

  versionSelect.on('change', function() {
    var version = this.value;

    window.location = '/' + version + '/';
  });
});
