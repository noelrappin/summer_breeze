// Note, this code is heavily based on the work of JB Steadman and 
// Jonathan Barnes. 
// see http://pivotallabs.com/users/jb/blog/articles/1152-javascripttests-bind-reality-

var sb = {}

sb.loadFixtureCount = 0;
sb.cachedFixtures = {};

sb.loadFixture = function(fixtureName) {
  var $destination = $('#jasmine_content');  
  $destination.html(sb.fixtureHtml(fixtureName));
  sb.loadFixtureCount++;
};

sb.findSelector = function(fixtureName, selector) {
  sb.loadFixture(fixtureName);
  return $('#jasmine_content').find(selector);
}

sb.readFixture = function(fixtureName) {
  return sb.fixtureHtml(fixtureName);
};

sb.fixtureHtml = function(fixtureName) {
  if (!sb.cachedFixtures[fixtureName]) {
    sb.cachedFixtures[fixtureName] = sb.retrieveFixture(fixtureName);
  }
  return sb.cachedFixtures[fixtureName];
};

sb.retrieveFixture = function(fixtureName) {
  var path = '/tmp/summer_breeze/' + fixtureName + ".html?" + new Date().getTime();
  var xhr;
  try {
    xhr = new jasmine.XmlHttpRequest();
    xhr.open("GET", path, false);
    xhr.send(null);
  } catch(e) {
    throw new Error("couldn't fetch " + path + ": " + e);
  }
  var regExp = new RegExp(/Couldn\\\'t load \/fixture/);
  if (regExp.test(xhr.responseText)) {
    throw new Error("Couldn't load fixture with key: '" + fixtureName + "'. No such file: '" + path + "'.");
  }

  return xhr.responseText;
};

sb.clearLiveEventBindings = function() {
  var events = jQuery.data(document, "events");
  for (prop in events) {
    delete events[prop];
  }
};

beforeEach(function() {
  $('#jasmine_content').empty();
  sb.clearLiveEventBindings();
  jasmine.Clock.useMock();
});

