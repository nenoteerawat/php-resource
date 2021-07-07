# ------------------------------------------------------------------------------
# policy for users allowing connection
# ------------------------------------------------------------------------------
resource "aws_iam_policy" "instance_connect" {
  name        = "instance-connect"
  path        = "/test/"
  description = "Allows use of EC2 instance connect"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
  		"Effect": "Allow",
  		"Action": "ec2-instance-connect:SendSSHPublicKey",
  		"Resource": "${aws_instance.module_ec2_frontend.arn}",
  		"Condition": {
  			"StringEquals": { "ec2:osuser": "${var.login_user_ec2}" }
  		}
  	},
		{
			"Effect": "Allow",
			"Action": "ec2:DescribeInstances",
			"Resource": "*"
		}
  ]
}
EOF
}

# data "aws_iam_instance_profile" "instance_connect" {
#   name = "instance-connect"
# }
