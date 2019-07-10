
title "Instances checks"

control "aws_instances_checks" do
  impact 1.0
  title "Be sure if the instance was start"
  describe aws_ec2_instance(name: 'Instance') do
    it { should be_running }
    its('public_dns_name') { should_not be_empty }
    its('tags') { should include(key: 'Environment', value: 'staging') }
  end
end
