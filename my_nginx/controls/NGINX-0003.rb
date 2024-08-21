control 'nginx-modules' do
  impact 1.0
  title 'NGINX modules'
  desc 'The required NGINX modules should be installed.'
  describe nginx do
    its('modules') { should include 'http_ssl' }
    its('modules') { should include 'stream_ssl' }
    its('modules') { should include 'mail_ssl' }
  end
end