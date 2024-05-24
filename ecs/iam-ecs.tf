
data "aws_iam_policy_document" "ec2_instance_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.cluster_name}-ecs-ec2-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_policy.json
}


resource "aws_iam_role_policy_attachment" "ec2-instance-role-attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_role" {
  name = "${var.cluster_name}-ecs-ec2-instance-role"
  role = aws_iam_role.ec2_instance_role.name
}


resource "aws_iam_role_policy" "cluster-ec2-role" {
  name = "${var.cluster_name}-cluster-ec2-role-policy"
  role = aws_iam_role.ec2_instance_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:PutAccountSetting",
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:ListTagsForResource",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "ssm:GetParameters"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
              "logs:*"
          ],
          "Resource": [
              "*"
          ]
        }
    ]
}
EOF

}


data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


// Anexando a policy AmazonEC2RoleforSSM na role ecs-une-dev-virginia-ec2-role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_instance_profile.ec2_instance_role.name
  policy_arn = data.aws_iam_policy.ssm.arn

}

data "aws_iam_policy" "cloudwatch-agent-admin" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}

// Anexando a policy AmazonEC2RoleforSSM na role ecs-une-dev-virginia-ec2-role
resource "aws_iam_role_policy_attachment" "cloudwatch-agent-admin" {
  role       = aws_iam_instance_profile.ec2_instance_role.name
  policy_arn = data.aws_iam_policy.cloudwatch-agent-admin.arn

}

resource "aws_iam_role_policy_attachment" "xray" {
  role       = aws_iam_instance_profile.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

}
