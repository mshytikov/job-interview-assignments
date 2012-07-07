class Api < Goliath::API

  use(Rack::Static,                     # render static files from ./public
      :root => Goliath::Application.app_path("public"),
      :urls => ['/super_upload.html', '/stylesheets', '/javascripts', '/images', '/uploads'])

  use Goliath::Rack::Params
  use Goliath::Rack::Formatters::JSON


  #Commented due to Params and rack.input  omg spent 1 hour to find the problem
  #def on_headers(env, headers)
    #env.logger.info 'received headers: ' + headers.inspect
  #end

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
    when '/upload'
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
    [
      200,
      {'Content-Type' => 'application/json'},
      { uuid: SecureRandom.uuid}
    ]
  end


  # POST /upload returns json with url to uploaded file
  #
  # @example
  #
  def upload(env)
    uuid = params['file_uuid']
    uploaded_file = params['file'] || {}
    tempfile = uploaded_file[:tempfile]
    
    return validation_error(400, "File not uploded") if tempfile.nil?

    url = "#{env.config[:server_url]}/uploads/#{uuid}"
    new_path = File.join(Goliath::Application.app_path("public"), "/uploads", uuid)
    FileUtils.mv(tempfile.path, new_path)
    [ 201, {'Content-Type' => 'application/json', 'Location' => url}, { url: url} ]
  end


end
