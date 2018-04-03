$(document).ready(function() {

  window.localLinkClicked = false;

  var cookieName = 'isReadingGuides';

  createCookie = function(name, value, days) {
    if ( !days ) { days = 100; }

    var date = new Date();
    date.setTime(date.getTime() + (days*24*60*60*1000));

    var expires = '; expires=' + date.toGMTString(),
        newCookie = name + '=' + value + expires + '; path=/';

    document.cookie = newCookie;
  };

  readCookie = function(name) {
    var nameSubstring = name + '=',
        cookieArray = document.cookie.split(';'),
        arrayLength = cookieArray.length,
        nameSubstringLength = nameSubstring.length;

    for (var i=0; i < arrayLength; i++) {
      var curCookie = cookieArray[i],
          curCookieLength = curCookie.length;

      while ( curCookie.charAt(0) === ' ') {
        curCookie = curCookie.substring(1, curCookieLength);
      }

      if (curCookie.indexOf(nameSubstring) === 0) {
        return curCookie.substring(nameSubstringLength, curCookieLength);
      }
    }

    return null;
  };

  eraseCookie = function(name) {
    createCookie(name, '', -1);
  };

  window.onbeforeunload = function() {
    if ( window.localLinkClicked ) { return; }
    eraseCookie(cookieName);
  };

  window.GUIDE_VERSIONS.onReady(function(versions) {
    var isReadingGuides = readCookie(cookieName);
    if ( isReadingGuides ) { return; }

    createCookie(cookieName, 1);

    var isOnAvailableVersion = ( $.inArray(versions.current, versions.available) !== -1 ),
        isNewestVersion = ( versions.current === versions.available[0] );

    if ( !isOnAvailableVersion || isNewestVersion ) { return; }

    var latestUrl = versions.urlFor(versions.latest);
    window.location.href = latestUrl;
  });

  $('a').on('click', function() {
    var isAbsolute = new RegExp('^([a-z]+://|//)', 'i');

    var domain = function(url) {
      return url.replace('http://','').replace('https://','').split('/')[0];
    };

    var url = $(this).attr('href'),
        isExternal = (
          isAbsolute.test(url) &&
          domain(location.href) !== domain(url)
        );

    if ( !isExternal ) {  window.localLinkClicked = true; }
  });

});
