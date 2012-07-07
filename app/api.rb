class Api < Goliath::API

  use(Rack::Static,                     # render static files from ./public
      :root => Goliath::Application.app_path("public"),
      :urls => ['/super_upload.html', '/stylesheets', '/javascripts', '/images'])

  def on_body(env, data)
    env.logger.info 'received data: ' + data
  end

  def response(env)
    [200, {}, "Hello World"]
  end


end
