Conf.uuid = null;
Conf.waiting_for_progress = false;
Conf.state = 'init';
Conf.save = false;


function fetchUUID(){
  var e = getIframeDoc().getElementById('uuid');
  return (e == null ? null : e.innerHTML)
};

function isIframeReady(){
  var iframe = document.getElementById('super_iframe')
  if (iframe == null){
    return false;
  } else if (Conf.uuid == null) {
    Conf.uuid = fetchUUID();
    return (Conf.uuid == null ? false : true)
  } else {
    return true;
  }
}

function checkIframeStatus(){
  if ( isIframeReady() ){
    var status = getIframeState();
    Conf.state = 'ready';
    if ( status == 'compleated') {
      uploadCompleated();
    } else {
      if (status == 'uploading') {
        Conf.state = 'waiting';
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
  setTimeout(checkIframeStatus, 100);
}


function setProgress(p){
  Conf.waiting_for_progress = false;
  var v = 0;
  if (p['state'] == 'done') {
    v = 100;
  } else {
    v = p['received']/p['size']*100;
  }
  document.getElementById('progress').innerHTML = Math.round(v);
};

function uploadCompleated(){
  document.getElementById('progress').innerHTML = "100";

  //copy url to main doc
  var link = getIframeDoc().getElementById('file_url')
  document.body.appendChild(link.cloneNode(true));

  //set hidden attachment value
  document.getElementById('attachment').value = link.getAttribute("href")

  //auto save form if needed
  if (Conf.save) { save() }
}

function updateProgress(){
  if ( Conf.waiting_for_progress == false ) {
    Conf.waiting_for_progress = true;
    sendJSONP("/progress/"+Conf.uuid, 'setProgress');
  }
}

function getIframeDoc()
{
  return  document.getElementById('super_iframe').contentWindow.document;
}


function save(){
  Conf.save = true;

  //dissable button
  document.getElementById('save_button').disabled = true;


  if (Conf.state == 'submission') {
    return true;
  }
  checkIframeStatus();
  if (Conf.state == 'ready') {
    Conf.state == 'submission';
    document.forms['save_form'].submit();
  } else {
    Conf.state = 'waiting';
    //show alert
    document.getElementById('alert').innerHTML = 'Saving attachment';

  }
  return false;
}
