class GitServerController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_action :check_if_login_required

  before_action do
    begin
      authenticate_or_request_with_http_basic do |username, password|
        @user = User.try_to_login(username, password, false)
        if @user.nil? or @user.new_record? or !@user.active?
          logger.info "(Git Server) Authentication failed from #{request.remote_ip} at #{Time.now.utc}"
          false
        else
          logger.info "(Git Server) Successful authentication for '#{@user.login}' from #{request.remote_ip} at #{Time.now.utc}"
          true
        end
      end
      next false unless @user
      project = Project.find(params[:id])
      unless project.module_enabled?("git_server")
        logger.warn "(Git Server) project '#{project.identifier}' doesn't have the git_server module enabled"
        render_404
        next false
      end
      repository = project.repositories.find_by_identifier_param(params[:repository_id])
      unless repository
        render_404
        next false
      end
      @grack_app = RedmineGitServer::GrackApp.new \
        request: request,
        repository_path: repository.url,
        allow_push: @user.allowed_to?(:commit_access, project),
        allow_pull: @user.allowed_to?(:view_changesets, project)
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end

  Grack::App::ROUTES.collect{|o| o[2] }.uniq.each do |action|
    define_method action do
      path = request.params["path"]
      params = action == :info_refs ? [] : [path]
      rack_response = @grack_app.send(action, *params)
      self.response = ActionDispatch::Response.new(*rack_response)
      response.sending!
    end
  end

end
