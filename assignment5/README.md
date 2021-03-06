This is test app for ServerUpload Challenge described in specification.pdf

Implemented usign [Goliath](https://github.com/postrank-labs/goliath)

### Core idea: ###

1. Use IFRAME as cross browser solution for file uploads.
Also it is easy to add usage of FileAPI in case of browser support it. But this is not the main goal.

2. File upload will be done in IFRAME using  regular form submission.
This form also will have file_uuid field which will be used as uniq identifier of file to track upload progress.

3. Track progress done via separate GET request with file_uuid as parameter (will be executed each 2s)

4. On saving the form will be submited with file_uuid and text
In case if file upload is in progress notification should be shown like  "submision will be done after file upload complete"

#### Notes: ####
1. Due to requirements to minimize dependencies I will use plain JS instead of jQuery.

2. Full page management will be done using JS.


### Instalation ###

```bash
  $ rvm install 1.9.3
  $ git clone https://github.com/mshytikov/super_upload.git
  $ cs super_upload
  $ bundle
```

### Run ###

```bash
  $ ruby super_upload.rb -sv
```

### Deployed demo ###

Demo deployed on Heroku  [HERE](http://mshytikov-super-upload.herokuapp.com/super_upload.html)


