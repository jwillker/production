# load data from Terraform output
content = inspec.profile.file('terraform.json')
params = JSON.parse(content)

# store values in variable
vpc_id = params['vpc_id']['value'][0]
public_subnets = params['public_subnets_id']['value']
private_subnets = params['private_subnets_id']['value']

title "VPC checks"

control "aws_vpc_default" do
  impact 0.1
  title "Find the default VPC..."
  describe aws_vpc do
    it { should exist }
  end
end

control "aws_vpc_check_cidr" do
  impact 1.0
  title "Check if cird_block is correct"
  describe aws_vpc(vpc_id: vpc_id) do
    it { should exist }
    its('cidr_block') { should cmp '10.0.0.0/16' }
  end
end

control "aws_public_subnets" do
  impact 1.0
  title "Check if all Public Subnets is include in this VPC as expect"
  describe aws_subnets.where( vpc_id: vpc_id) do
    public_subnets.each do |subnet|
      its('subnet_ids') { should include subnet }
      its('states') { should_not include 'pending' }
    end
  end
  # Loop in each subnet and verify if the ip range
  public_subnets.each do |subnet|
    describe aws_subnet(subnet_id: subnet) do
      its('available_ip_address_count') { should eq 4090 }
    end
  end
end

control "aws_private_subnets" do
  impact 1.0
  title "Check if all Private Subnets is include in this VPC"
  describe aws_subnets.where( vpc_id: vpc_id) do
    private_subnets.each do |subnet|
      its('subnet_ids') { should include subnet }
      its('states') { should_not include 'pending' }
    end
  end
  # Loop in each subnet and verify if the ip range
  private_subnets.each do |subnet|
    describe aws_subnet(subnet_id: subnet) do
      its('available_ip_address_count') { should eq 4091 }
    end
  end
end


control "aws_vpc_route_table" do
  impact 1.0
  title "Check if Route tables is include in this VPC"
  describe aws_route_tables do
    its('vpc_ids') { should include vpc_id }
  end
end

