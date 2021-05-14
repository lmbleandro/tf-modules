//data "aws_iam_policy_document" "ecs_task_execution_role" {
//  version = "2012-10-17"
//  statement {
//    sid     = ""
//    effect  = "Allow"
//    actions = ["sts:AssumeRole"]
//
//    principals {
//      type        = "Service"
//      identifiers = ["ecs-tasks.amazonaws.com"]
//    }
//  }
//}
//
//resource "aws_iam_role" "ecs_task_execution_role" {
//  name               = "${local.app_name}-ecs-task-execution"
//  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
//}
//
//resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
//  role       = aws_iam_role.ecs_task_execution_role.name
//  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
//}
//
//data "aws_iam_policy_document" "ecs_auto_scale_role" {
//  version = "2012-10-17"
//  statement {
//    sid     = ""
//    effect  = "Allow"
//    actions = ["sts:AssumeRole"]
//
//    principals {
//      type        = "Service"
//      identifiers = ["application-autoscaling.amazonaws.com"]
//    }
//  }
//}
//
//resource "aws_iam_role" "ecs_auto_scale_role" {
//  name               = "${local.app_name}-ecs-auto-scale-role"
//  assume_role_policy = data.aws_iam_policy_document.ecs_auto_scale_role.json
//}
//
//resource "aws_iam_role_policy_attachment" "ecs_auto_scale_execution_role" {
//  role       = aws_iam_role.ecs_task_execution_role.name
//  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
//}


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
  name               = "${local.app_name}-ecs-ec2-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_policy.json
}


resource "aws_iam_role_policy_attachment" "ec2-instance-role-attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_role" {
  name = "${local.app_name}-ecs-ec2-instance-role"
  role = aws_iam_role.ec2_instance_role.name
}


resource "aws_iam_role_policy" "cluster-ec2-role" {
  name = "${local.app_name}-cluster-ec2-role-policy"
  role = aws_iam_role.ec2_instance_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
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


resource "aws_iam_role_policy_attachment" "xray" {
  role       = aws_iam_instance_profile.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

}
