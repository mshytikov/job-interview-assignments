class Api < Goliath::API

  use(Rack::Static,                     # render static files from ./public
      :root => Goliath::Application.app_path("public"),
      :urls => ['/super_upload.html', '/stylesheets', '/javascripts', '/images', '/uploads'])

  use Goliath::Rack::Params
  use Goliath::Rack::Formatters::JSON


  #Commented due to Params and rack.input  omg spent 1 hour to find the problem
  def on_headers(env, headers)
    env.logger.info 'received headers: ' + headers.inspect
  end

  #def on_body(env, data)
    #env.logger.info 'received data: ' + data
  #end

  def response(env)
    #simple hand made routing due to routing was removed from goliath
    case env['PATH_INFO']
    when '/'
      hello_world
    when '/uuid.json'
      uuid
    when /\A\/progress\/(.+)/
      progress(env, $1)
    when /\A\/upload\/(.+)/
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

    url = "#{env.config[:server_url]}/uploads/#{uuid}"
    new_path = full_file_path(uuid)
    FileUtils.mv(tempfile.path, new_path)
    [ 201, {'Content-Type' => 'application/json', 'Location' => url}, { url: url} ]
  end

  # GET /progress/:file_uuid returns json with progress
  #
  # @example
  #   #=> {"state":"done"}
  #   #=> {"state":"uploading", "received":10, "size":110}
  #
  def progress(env, file_uuid)
    if p = env.config[:progress][file_uuid]
      [ 200, {'Content-Type' => 'application/json'}, p ]
    elsif File.exists?(full_file_path(file_uuid))
      [ 200, {'Content-Type' => 'application/json'}, { state: "done" } ] 
    else
      raise Goliath::Validation::NotFoundError
    end
  end


end
