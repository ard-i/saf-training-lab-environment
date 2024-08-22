control 'nginx-version' do
  impact 1.0
  title 'NGINX version'
  desc 'The required version of NGINX should be installed.'
  describe nginx do
    its('version') { should cmp >= input('org_allowed_nginx_version') }
  end
end

control 'nginx-modules' do
  impact 1.0
  title 'NGINX modules'
  desc 'The required NGINX modules should be installed.'

  nginx_modules = input('nginx_modules')
  
  describe nginx do
    nginx_modules.each do |current_module|
      its('modules') { should include current_module }
    end
  end
end

control 'nginx-shell-access' do
  impact 1.0
  title 'NGINX shell access'
  desc 'The NGINX shell access should be restricted to admin users.'
  describe users.shells(/bash/).usernames do
    it { should be_in input('admin_users')}
  end
end

control 'nginx-conf-perms' do
  impact 1.0
  title 'NGINX configuration'
  desc 'The NGINX config file should owned by root, be writable only by owner, and not writeable or and readable by others.'
  describe file('/etc/nginx/nginx.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end

control 'nginx-shell-access' do
  impact 1.0
  title 'NGINX shell access'
  desc 'The NGINX shell access should be restricted to admin users.'
  describe users.shells(/bash/).usernames do
    it { should be_in ['root'] }
  end
end

control 'Requirement 6' do
  impact 1.0
  title 'Checking that /etc/nginx does not return empty'
  desc 'Let\'s do this the ugly way.'
  describe command('ls -al').stdout.strip do
    it { should_not be_empty }
  end
end

control 'Requirement 6.5' do
  impact 1.0
  title 'Checking that /etc/nginx does not return empty'
  desc 'Let\'s do this the concise way.'
  describe "The /etc/nginx directory" do
    subject { command('ls -al').stdout.strip }
    it { should_not be_empty }
  end
end

## the checks below give the same result, but the difference is in output readability preference

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
end

describe file('/etc/nginx/nginx.conf') do
  it 'must be a file' do
    expect(subject).to(be_file)
  end
end

## Below is a nicer way of doing the "nginx-shell-access" control above

non_admin_users = users.shells(/bash/).usernames
describe "Shell access for non-admin users" do
  it "should be removed." do
    failure_message = "These non-admin should not have shell access: #{non_admin_users.join(", ")}"
    expect(non_admin_users).to eq(input('admin_users')), failure_message
  end
end

bad_users = inspec.shadow.where { password != "*" && password != "!" && password !~ /\$6\$/ }.users # note that SHA12-encrypted passwords are marked by starting with '$6$' in /etc/shadow

describe 'Password hashes in /etc/shadow' do
  it 'should only contain SHA512 hashes' do
    failure_message = "Users without SHA512 hashes: #{bad_users.join(', ')}"
    expect(bad_users).to be_empty, failure_message
  end
end

command('find ~/* -type f -maxdepth 0 -xdev').stdout.split.each do |fname|  # we need to be careful about using 'find' --
  # there could be a LOT of output if we are not specific enough with the search!
  describe file(fname) do
    its('owner') { should cmp 'ec2-user' }
  end
end

control 'nginx-interview' do
  impact 1.0
  title 'Interview'
  desc 'Interview!'
  describe "manual" do
    skip "nginx interview"
  end
end

