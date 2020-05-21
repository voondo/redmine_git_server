module RedmineGitServer
  class Hooks < Redmine::Hook::ViewListener

    # Add our css/js on each page
    def view_layouts_base_html_head(context)
      tags = stylesheet_link_tag('git_server.css', plugin: 'redmine_git_server')
      tags += javascript_include_tag('git_server.js', plugin: 'redmine_git_server')
    end

  end
end
