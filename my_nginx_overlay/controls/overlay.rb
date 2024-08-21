include_controls 'my_nginx' do
  skip_control 'nginx-conf-perms'
  control 'nginx-modules' do
    impact 0.5
  end
end