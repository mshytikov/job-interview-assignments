class Api < Goliath::API

  UPLOAD_ENDPOINT = /\A\/upload\/(.+)/

  use(Rack::Static,                     # render static files from ./public
      :root => Goliath::Application.app_path("public"),
      :urls => ['/super_iframe.html', '/super_upload.html', '/stylesheets', '/javascripts', '/images', '/uploads'])

  use Goliath::Rack::Params
  use Goliath::Rack::JSONP
  use Goliath::Rack::Formatters::JSON



  def on_headers(env, headers)
    init_progress(env, headers) if env['PATH_INFO'] =~ UPLOAD_ENDPOINT
  end

  def on_body(env, data)
    move_progress(env, data) if env['PATH_INFO'] =~ UPLOAD_ENDPOINT
    env[RACK_INPUT] << data
  end

  def on_close(env)
    delete_progress(env) if env['PATH_INFO'] =~ UPLOAD_ENDPOINT
  end

  def uuid_from_env(env)
    env['PATH_INFO'][UPLOAD_ENDPOINT, 1]
  end

  def delete_progress(env)
    uuid = uuid_from_env(env)
    env.config[:progress].delete(uuid)
    env.logger.info "Upload ended. Active uploads = %s"%[env.config[:progress].size]
  end
  
   
  def init_progress(env, headers)
    uuid = uuid_from_env(env)
    size =  headers['Content-Length'].to_i
    env.config[:progress][uuid] = { state: "uploading", received: 0, size: size }
    env.logger.info "New upload started. Active uploads = %s"%[env.config[:progress].size]
  end

  def move_progress(env, data)
    uuid = uuid_from_env(env)
    env.config[:progress][uuid][:received] += data.bytesize
  end


  def response(env)
    #simple hand made routing due to routing was removed from goliath
    case env['PATH_INFO']
    when '/'
      hello_world
    when '/save'
      save(env)
    when /\A\/uuid.json/
      uuid
    when /\A\/progress\/(.+)/
      progress(env, $1)
    when UPLOAD_ENDPOINT
      only_post_allowed!(env)
      upload(env, $1)
    else
      raise Goliath::Validation::NotFoundError
    end
  end

  def only_post_allowed!(env)
    raise(Goliath::Validation::MethodNotAllowedError) if env[Goliath::Request::REQUEST_METHOD] != 'POST'
  end

  def full_file_path(file_uuid)
    File.join(Goliath::Application.app_path("public"), "/uploads", file_uuid)
  end


  def hello_world
    [200, {}, 'Hello World']
  end


  # GET /uuid.json returns new uuid
  # 
  # @example
  #   $ curl localhost:9000/uuid.json
  #   #=> {"uuid":"86430adf-3b81-4fd2-b4fe-625b73c2fd6c"}
  # 
  def uuid
    [
      200,
      {'Content-Type' => 'application/json'},
      { uuid: SecureRandom.uuid}
    ]
  end


  # POST /upload returns json with url to uploaded file
  #
  # @example
  #   $ curl -X POST  -F file=@spec/fixtures/files/upload1.txt http://localhost:9000/upload/file-uuid
  #   #=> {"url":"http://localhost:9000/uploads/file-uuid"}
  #
  def upload(env, uuid)
    uploaded_file = params['file'] || {}
    tempfile = uploaded_file[:tempfile]
    
    return validation_error(400, "File not uploded") if tempfile.nil?

    extension = File.extname(uploaded_file[:filename])
    uuid += extension
    url = "/uploads/#{uuid}"
    new_path = full_file_path(uuid)
    FileUtils.mv(tempfile.path, new_path)
    [ 201, {'Content-Type' => 'text/html', 'Location' => url},
      "<div id='state'>compleated</div><a id='file_url' href='#{url}'>Uploaded to here</a>"
    ]
  end

  # GET /progress/:file_uuid returns json with progress
  #
  # @example
  #   #=> {"state":"done"}
  #   #=> {"state":"uploading", "received":10, "size":110}
  #
  def progress(env, file_uuid)
    if File.exists?(full_file_path(file_uuid))
      [ 200, {'Content-Type' => 'application/json'}, { state: "done" } ] 
    elsif p = env.config[:progress][file_uuid]
      [ 200, {'Content-Type' => 'application/json'}, p ]
    else
      #FIXME should raise  Goliath::Validation::NotFoundError
      #but JSONP can't hadle this correctly
      e = Goliath::Validation::NotFoundError.new
      validation_error(e.status_code, e.message, {'Content-Type' => 'application/json'})
    end
  end

  # POST /save returns form fields
  #
  def save(env)
    body = "<div>#{params['title']}<div>"
    body += "<a id='file_url' href='#{params['attachment']}'>Attachment</a>" if params['attachment'].=~ /\Ahttp/
    [ 201, {'Content-Type' => 'text/html'}, body ]
  end


end
