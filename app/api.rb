class Api < Goliath::API
  use Goliath::Rack::Tracer
  def on_body(env, data)
    env.logger.info 'received data: ' + data
  end

  def response(env)
    [200, {}, "Hello World"]
  end
end
