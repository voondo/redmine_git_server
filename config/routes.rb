
Grack::App::ROUTES.each do |grack_route|
  regex = grack_route[0]
  method = grack_route[1].downcase.to_sym
  action = grack_route[2]
  match 'projects/:id/repository/:repository_id/*path',
    controller: 'git_server', 
    action: action, 
    via: method,
    format: false,
    constraints: -> (request) {
      regex.match(request.path)
    }
end

