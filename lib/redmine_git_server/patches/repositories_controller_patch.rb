require_dependency 'repositories_controller'

module RepositoriesControllerWithGitServerSupport

  def show_error_not_found
    return super if params[:action] != 'show'
    render action: 'empty'
  end

end

RepositoriesController.send(:prepend, RepositoriesControllerWithGitServerSupport)
