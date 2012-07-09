module ApiHelperMethods

  UPLOAD_ENDPOINT = /\A\/upload\/(.+)/

  def only_post_allowed!(env)
    raise(Goliath::Validation::MethodNotAllowedError) if env[Goliath::Request::REQUEST_METHOD] != 'POST'
  end

  def full_file_path(file_uuid)
    File.join(Goliath::Application.app_path("public"), "/uploads", file_uuid)
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

  def upload_endpoint(env)
    !uuid_from_env(env).nil?
  end 

  #FIXME here I want to use templates ( Goliath::Rack::Templates)
  # But according to requirements to minimize dependencies I will do plain rendering
  def render(view, locals)
    case view
    when :uploaded
      "<div id='state'>compleated</div><a id='file_url' href='#{locals[:url]}'>Uploaded to here</a>"
    when :saved
      body = "<h1>Saved</h1><h4>Title:</h4><div>#{locals['title']}</div><h4>Attachemnt:</h4>"
      if locals['attachment'].to_s.empty?
        body << "<div>No attachements</div>"
      else
        body << "<a id='file_url' href='#{locals['attachment']}'>Download</a>" 
      end
      body
    else 
      raise "Unknown view"
    end
  end
end
