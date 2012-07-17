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

  #returns path to file
  def save_uploaded_file(env, file)
    uploaded_file = file || {}
    tempfile = uploaded_file[:tempfile]
    return nil if tempfile.nil?

    uuid = uuid_from_env(env)
    extension = File.extname(uploaded_file[:filename])
    uuid += extension
    new_path = full_file_path(uuid)
    FileUtils.mv(tempfile.path, new_path)
    "/uploads/#{uuid}"
  end

end
