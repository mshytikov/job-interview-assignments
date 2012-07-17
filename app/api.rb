class Api < Goliath::API
  include ApiHelperMethods
  include Goliath::Rack::Templates

  # render static files from ./public
  use(Rack::Static,
      :root => Goliath::Application.app_path("public"),
      :urls => ['/super_iframe.html', '/super_upload.html', '/stylesheets', '/javascripts', '/images', '/uploads'])

  use Goliath::Rack::Params
  use Goliath::Rack::JSONP
  use Goliath::Rack::Formatters::JSON

  def self.match(pattern)
    %r{\A#{pattern}\z}
  end

  ENDPOINTS = {
    root:       match('/'),
    save:       match('/save'),
    uuid:       match('/uuid.json'),
    upload:     match('/upload/(.+)'),
    progress:   match('/progress/(.+)'),
  }

  def route_to_action(env)
    #simple hand made routing due to routing was removed from goliath
    route_to = ENDPOINTS.find{|k,v| env['PATH_INFO'] =~ v}
    if route_to
      env[:uuid] = $1
      send("#{route_to.first}", env)
    else
      raise Goliath::Validation::NotFoundError
    end
  end



  def on_headers(env, headers)
    init_progress(env, headers) if upload_endpoint(env)
  end

  def on_body(env, data)
    move_progress(env, data) if upload_endpoint(env)
    env[RACK_INPUT] << data
  end

  def on_close(env)
    delete_progress(env) if upload_endpoint(env)
  end

  def response(env)
    route_to_action(env)
  end

  def root(env)
    [200, {}, 'Hello World']
  end


  # GET /uuid.json returns new uuid
  # 
  # @example
  #   $ curl localhost:9000/uuid.json
  #   #=> {"uuid":"86430adf-3b81-4fd2-b4fe-625b73c2fd6c"}
  # 
  def uuid(env)
    [ 200, {'Content-Type' => 'application/json'}, { uuid: SecureRandom.uuid} ]
  end


  # POST /upload returns json with url to uploaded file
  #
  # @example
  #   $ curl -X POST  -F file=@spec/fixtures/files/upload1.txt http://localhost:9000/upload/file-uuid
  #   #=> {"url":"http://localhost:9000/uploads/file-uuid"}
  #
  def upload(env)
    url = save_uploaded_file(env, params['file'])
    if url
      [ 201, {'Content-Type' => 'text/html', 'Location' => url}, haml(:uploaded, :locals => {:url => url}) ]
    else
      validation_error(400, "File not uploded")
    end
  end

  # GET /progress/:file_uuid returns json with progress
  #
  # @example
  #   #=> {"state":"done"}
  #   #=> {"state":"uploading", "received":10, "size":110}
  #
  def progress(env)
    status =  progress_status(env)
    if status
      [ 200, {'Content-Type' => 'application/json'}, status] 
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
    locals  = {title: params['title'], attachment: params['attachment']}
    [201, {}, haml(:saved, :locals => locals )]
  end


end
