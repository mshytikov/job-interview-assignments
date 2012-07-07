class Api < Goliath::API

  use(Rack::Static,                     # render static files from ./public
      :root => Goliath::Application.app_path("public"),
      :urls => ['/super_upload.html', '/stylesheets', '/javascripts', '/images'])

  use Goliath::Rack::Formatters::JSON



  def on_body(env, data)
    env.logger.info 'received data: ' + data
  end

  def response(env)
    #simple hand made routing due to routing was removed from goliath
    case env['PATH_INFO']
    when '/'
      hello_world
    when '/uuid.json'
      uuid
    else
      raise Goliath::Validation::NotFoundError
    end
  end

  def hello_world
    [200, {}, 'Hello World']
  end

  def uuid
    [
      200,
      {'Content-Type' => 'application/json'},
      { :uuid => SecureRandom.uuid}
    ]
  end


end
