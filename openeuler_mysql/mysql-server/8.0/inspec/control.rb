control 'container' do
  impact 0.5
  describe docker_container('mysql-server-8.0') do
    it { should exist }
    it { should be_running }
    its('repo') { should eq 'mysql/mysql-server' }
    its('ports') { should eq '3306/tcp, 33060-33061/tcp' }
    its('command') { should match '/entrypoint.sh mysqld' }
  end
end
control 'packages' do
  impact 0.5
  describe package('mysql-community-server-minimal') do
    it { should be_installed }
    its ('version') { should match '8.0.28.*' }
  end
  describe package('mysql-shell') do
    it { should be_installed }
    its ('version') { should match '8.0.28.*' }
  end
end
