// Just copypaste from google
var ENV = {
  jsonpElement : null
}
function sendJSONP(url, callback) {
  if (!url || !callback){
    return;
  }

  url += '?callback='+callback+'&random'+ Math.random();

  var e = ENV.jsonpElement;
  if (e) {
    e.parentNode.removeChild(e);
  }

  e = document.createElement('script');
  e.setAttribute('type','text/javascript');
  document.getElementsByTagName('head')[0].appendChild(e);
  e.setAttribute('src', url);
  ENV.jsonpElement = e;
}

