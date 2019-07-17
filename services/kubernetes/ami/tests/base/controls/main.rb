title 'AMI compliance'

control 'Kubernetes Packages' do
  impact 1.0
  title 'Verify kubernetes packages is installed...'
  describe package('kubelet') do
    it { should be_installed }
    its('version') { should eq '1.13.5-00' }
  end
  describe package('kubeadm') do
    it { should be_installed }
    its('version') { should eq '1.13.5-00' }
  end
  describe package('kubectl') do
    it { should be_installed }
    its('version') { should eq '1.13.5-00' }
  end
  describe package('kubernetes-cni') do
    it { should be_installed }
    its('version') { should eq '0.7.5-00' }
  end
  describe package('docker-ce') do
    it { should be_installed }
  end
end

control 'Services' do
  impact 1.0
  title 'Verify essencial services is running...'
  describe service('docker') do
    it { should be_enabled }
    it { should be_running }
  end
  describe service('kubelet') do
    it { should be_enabled }
  end
end

control 'Kubeadm Config' do
  impact 1.0
  title 'Verify if file is present...'
  describe file('/opt/kubeadm-config.yaml') do
    its('type') { should cmp 'file' }
    it { should be_file }
    it { should_not be_symlink }
    it { should_not be_directory }
    it { should be_allowed('read') }
  end
end

describe interface('eth0') do
  it { should be_up }
end

#describe mount('bpffs') do
#  it { should be_mounted }
#  its('device') { should eq  'bpffs' }
#  its('type') { should eq  'bpf' }
#  its('options') { should eq 'rw' }
#end
#
