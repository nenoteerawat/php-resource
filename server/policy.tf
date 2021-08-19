// ############ Policy for Ec2 ############
resource "aws_iam_role" "module_ec2_iam_role" {
  name               = "${var.name}-ec2-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

resource "aws_iam_policy" "AWSCodeDeployEc2Role" {
  name        = "AWSCodeDeployEc2Role"
  description = "Policy for codedeploy Ec2 instance"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
          "Action": [
              "s3:Get*",
              "s3:List*"
          ],
          "Effect": "Allow",
          "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployEc2Role" {
  policy_arn = aws_iam_policy.AWSCodeDeployEc2Role.arn
  role       = aws_iam_role.module_ec2_iam_role.name
}

resource "aws_iam_instance_profile" "module_ec2_iam_instance_profile" {
  name = "${var.name}-ec2-iam-instance-profile"
  role = aws_iam_role.module_ec2_iam_role.name
}

// ############ Policy for AGS ############
resource "aws_iam_role" "module_codedeploy_iam_role" {
  name = "${var.name}-codedeploy-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Sid": "FirstStatement",
            "Effect": "Allow",
            "Principal":
            {
                "Service": "codedeploy.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
resource "aws_iam_policy" "AWSCodeDeployRoleAddition" {
  name        = "AWSCodeDeployRoleAddition"
  description = "Policy for codedeploy autoscale with template"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Action":
            [
                "ec2:RunInstances*",
                "ec2:CreateTags*",
                "autoscaling:Describe*",
                "autoscaling:EnterStandby",
                "autoscaling:ExitStandby",
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:SuspendProcesses",
                "autoscaling:ResumeProcesses"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action":
            [
                "iam:PassRole*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.module_codedeploy_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleAddition" {
  policy_arn = aws_iam_policy.AWSCodeDeployRoleAddition.arn
  role       = aws_iam_role.module_codedeploy_iam_role.name
}
