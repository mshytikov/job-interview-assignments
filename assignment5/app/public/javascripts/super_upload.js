ENV.uuid = null;
ENV.waiting_for_progress = false; //flag for progress
ENV.state = 'init';
ENV.save = false; //flag for user click on save


function fetchUUID(){
  var e = getIframeDoc().getElementById('uuid');
  return (e == null ? null : e.innerHTML)
};

function isIframeReady(){
  var iframe = document.getElementById('super_iframe')
  if (iframe == null){
    return false;
  } else if (ENV.uuid == null) {
    ENV.uuid = fetchUUID();
    return (ENV.uuid == null ? false : true)
  } else {
    return true;
  }
}

function checkIframeStatus(){
  if ( isIframeReady() ){
    var status = getIframeState();
    ENV.state = 'ready';
    if ( status == 'compleated') {
      uploadCompleated();
    } else {
      if (status == 'uploading') {
        ENV.state = 'waiting';
        updateProgress();
      }
      setTimer();
    }
  } else {
    setTimer();
  }
}

function getIframeState(){
  var e = getIframeDoc().getElementById('state');
  return (e == null ? 'init' : e.innerHTML)
}

function setTimer(){
  setTimeout(checkIframeStatus, 1000);
}


function setProgress(p){
  ENV.waiting_for_progress = false;
  var v = 0;
  if (p['state']) {
    if (p['state'] == 'done') {
      v = 100;
    } else {
      v = p['received']/p['size']*100;
    }
    document.getElementById('progress').innerHTML = Math.round(v);
  }
};

function uploadCompleated(){
  document.getElementById('progress').innerHTML = "100";

  //copy url to main doc
  var link = getIframeDoc().getElementById('file_url')

  //set hidden attachment value
  document.getElementById('attachment').value = link.getAttribute("href")

  var iframe = document.getElementById('super_iframe');
  iframe.parentNode.replaceChild(link.cloneNode(true), iframe);


  //auto save form if needed
  if (ENV.save) { save() }
}

function updateProgress(){
  if ( ENV.waiting_for_progress == false ) {
    document.getElementById('super_iframe').setAttribute("style", "display: none;");
    ENV.waiting_for_progress = true;
    sendJSONP("/progress/"+ENV.uuid, 'setProgress');
  }
}

function getIframeDoc()
{
  return  document.getElementById('super_iframe').contentWindow.document;
}


function save(){
  if (ENV.save == false) {
    //dissable button
    document.getElementById('save_button').disabled = true;
    
    ENV.save = true;
  }

  if (ENV.state == 'submission') {
    return true;
  }

  if (ENV.state == 'ready') {
    ENV.state == 'submission';
    document.forms['save_form'].submit();
  } else {
    ENV.state = 'waiting';
    //show alert
    document.getElementById('alert').innerHTML = 'Saving attachment';

  }
  return false;
}
