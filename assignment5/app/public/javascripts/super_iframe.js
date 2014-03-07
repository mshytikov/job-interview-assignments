function updateUUID(hash){
  var uuid = hash['uuid'];
  document.getElementById('uuid').innerHTML = uuid;

  var action = document.getElementById('super_form').action; 
  document.getElementById('super_form').action = action + uuid;
  document.getElementById('state').innerHTML = 'ready';
}

function startUpload(){
  document.getElementById('state').innerHTML= 'uploading';
  autosubmit();
}

function autosubmit(){
  document.getElementById('super_form').submit();
}
