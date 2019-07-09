# load data from Terraform output
content = inspec.profile.file('terraform.json')
params = JSON.parse(content)

# store values in variable
sgs = params['security_group_id']['value']

title "Security Groups checks"

control "aws_security_group_checks" do
  impact 0.5
  title "Check Security Group web rules"
  describe aws_security_group(group_name: 'web') do
    it { should allow_in(port: 80, ipv4_range: '0.0.0.0/0') }
    it { should allow_in(port: 443, ipv4_range: '0.0.0.0/0') }
  end
end

control "aws_security_group_checks" do
  impact 0.5
  title "Check Security Group web rules"
  sgs.each do |sg|
    describe aws_security_group(id: sg) do
      # Do not allow unrestricted SSH access.
      it { should_not allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
      # Do not allow unrestricted RDP access.
      it { should_not allow_in(port: 3389, ipv4_range: '0.0.0.0/0') }
    end
  end
end
