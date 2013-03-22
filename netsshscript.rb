require 'net/ssh'

Net::SSH.start("ec2-54-232-196-174.sa-east-1.compute.amazonaws.com", "ec2-user", :auth_methods => 
["publickey"], :keys => ["/Users/damianferrai/.ssh/da"]) 


@end