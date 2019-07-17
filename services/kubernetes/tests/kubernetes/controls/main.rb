
describe interface('eth0') do
  it { should be_up }
end

control 'Services' do
  impact 1.0
  title 'Verify essencial services is running...'
  describe service('kubelet') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe command('sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes | wc -l') do
  its('stdout') { should eq "7\n" }
end
