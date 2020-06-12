Redmine::Plugin.register :redmine_git_server do
  name 'Redmine Git Server plugin'
  author 'Romain Lalaut'
  description 'This is a plugin for Redmine allowing to serve the git repositories through the http connection'
  url 'https://github.com/voondo/redmine_git_server'
  version '0.4'
  author_url 'https://github.com/voondo'
  project_module :git_server do
    permission :enable_git_server, {}
  end
end

require_dependency 'redmine_git_server/hooks'

app = Rails.application
app.config.to_prepare do
  plugin = Redmine::Plugin.find(:redmine_git_server)
  plugin.requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
  plugin.requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  require_dependency 'redmine_git_server/patches/repositories_controller_patch'
end
