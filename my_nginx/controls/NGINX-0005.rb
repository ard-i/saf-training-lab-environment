control 'nginx-shell-access' do
  impact 1.0
  title 'NGINX shell access'
  desc 'The NGINX shell access should be restricted to admin users.'
  describe users.shells(/bash/).groups do
    it { should be_in [['root']] }
  end
end