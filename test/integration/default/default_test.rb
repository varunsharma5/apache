# InSpec test for recipe apache::default

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/
describe port(80) do
  ir { should be_listening }
end

describe package('apache2') do
  it { should be_installed }
end

describe file ('/var/www/html/index.html') do
  it { should exist }
  its('content') { should match (/Hello Pipeline World!/) }
end

describe upstart_service('apache2') do
  it { should be_enabled}
  it { should be_running}
end
