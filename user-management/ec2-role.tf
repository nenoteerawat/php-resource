resource "aws_iam_role" "instance_connect" {
  name        = "instance-connect"
  description = "privileges for the instance-connect demonstration"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com", "ssm.amazonaws.com" ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "instance_connect" {
  role       = aws_iam_role.instance_connect.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "instance_connect" {
  name = "instance-connect"
  role = aws_iam_role.instance_connect.id
}
