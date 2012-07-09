class Api < Goliath::API
  include ApiHelperMethods

  # render static files from ./public
  use(Rack::Static,
      :root => Goliath::Application.app_path("public"),
      :urls => ['/super_iframe.html', '/super_upload.html', '/stylesheets', '/javascripts', '/images', '/uploads'])

  use Goliath::Rack::Params
  use Goliath::Rack::JSONP
  use Goliath::Rack::Formatters::JSON

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
    when /\A\/upload\/(.+)/
      only_post_allowed!(env)
      upload(env)
    else
      raise Goliath::Validation::NotFoundError
    end
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
    [ 200, {'Content-Type' => 'application/json'}, { uuid: SecureRandom.uuid} ]
  end


  # POST /upload returns json with url to uploaded file
  #
  # @example
  #   $ curl -X POST  -F file=@spec/fixtures/files/upload1.txt http://localhost:9000/upload/file-uuid
  #   #=> {"url":"http://localhost:9000/uploads/file-uuid"}
  #
  def upload(env)
    uploaded_file = params['file'] || {}
    tempfile = uploaded_file[:tempfile]
    
    return validation_error(400, "File not uploded") if tempfile.nil?

    uuid = uuid_from_env(env)
    extension = File.extname(uploaded_file[:filename])
    uuid += extension
    url = "/uploads/#{uuid}"
    new_path = full_file_path(uuid)
    FileUtils.mv(tempfile.path, new_path)

    [ 201, {'Content-Type' => 'text/html', 'Location' => url}, render(:uploaded, {:url => url}) ]
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
    [201, {}, render(:saved, params)]
  end


end
