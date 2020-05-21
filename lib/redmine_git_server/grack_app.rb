module RedmineGitServer
  class GrackApp < Grack::App

    def initialize opts
      @request = opts.fetch(:request, nil)
      @env = @request.env
      @git = RedmineGitServer::GrackGitAdapter.new Redmine::Scm::Adapters::GitAdapter::GIT_BIN
      @git.repository_path = opts.fetch(:repository_path, nil)
      @allow_push = opts.fetch(:allow_push, nil)
      @allow_pull = opts.fetch(:allow_pull, nil)
      @request_verb = @request.method
    end

  end
end
