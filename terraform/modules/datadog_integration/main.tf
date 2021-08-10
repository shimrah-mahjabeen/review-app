

# ============== Configure the Datadog provider ==============

terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# ============== IAM  ==============

data "aws_iam_policy_document" "datadog_integration_iam_policy_document" {
  # https://docs.datadoghq.com/integrations/amazon_web_services/?tab=allpermissions#datadog-aws-iam-policy
  statement {
    sid = "all"

    effect = "Allow"

    actions = [
      "apigateway:GET",
      "autoscaling:Describe*",
      "budgets:ViewBudget",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codedeploy:List*",
      "codedeploy:BatchGet*",
      "directconnect:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:List*",
      "elasticmapreduce:Describe*",
      "es:ListTags",
      "es:ListDomainNames",
      "es:DescribeElasticsearchDomains",
      "health:DescribeEvents",
      "health:DescribeEventDetails",
      "health:DescribeAffectedEntities",
      "kinesis:List*",
      "kinesis:Describe*",
      "lambda:AddPermission",
      "lambda:GetPolicy",
      "lambda:List*",
      "lambda:RemovePermission",
      "logs:Get*",
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:TestMetricFilter",
      "logs:PutSubscriptionFilter",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeSubscriptionFilters",
      "rds:Describe*",
      "rds:List*",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "route53:List*",
      "s3:GetBucketLogging",
      "s3:GetBucketLocation",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
      "ses:Get*",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "states:ListStateMachines",
      "support:*",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "datadog_integration_iam_policy" {
  name_prefix = "DatadogAWSIntegrationPolicy"
  policy      = data.aws_iam_policy_document.datadog_integration_iam_policy_document.json
}

resource "aws_iam_role_policy_attachment" "datadog_integration_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.datadog_integration_iam_policy.arn
  role       = aws_iam_role.datadog_integration_iam_role.name
}

data "aws_iam_policy_document" "datadog_integration_assume_role_iam_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = [
        "arn:aws:iam::${local.datadog_aws_account_id}:root",
      ]

      type = "AWS"
    }

    condition {
      test = "StringEquals"

      values = [
        datadog_integration_aws.aws_integration.external_id,
      ]

      variable = "sts:ExternalId"
    }
  }
}

resource "aws_iam_role" "datadog_integration_iam_role" {
  name               = "DatadogAWSIntegrationRole"
  assume_role_policy = data.aws_iam_policy_document.datadog_integration_assume_role_iam_policy_document.json
}

resource "datadog_integration_aws" "aws_integration" {
  account_id  = var.aws_account_id
  role_name   = "DatadogAWSIntegrationRole"
  filter_tags = ["Service:${var.service}"]
  account_specific_namespace_rules = {
    api_gateway            = false
    application_elb        = true
    appstream              = false
    appsync                = false
    athena                 = false
    auto_scaling           = true
    billing                = false
    budgeting              = true
    cloudfront             = true
    cloudhsm               = false
    cloudsearch            = false
    cloudwatch_events      = true
    cloudwatch_logs        = true
    codebuild              = false
    cognito                = false
    collect_custom_metrics = true
    connect                = false
    crawl_alarms           = true
    directconnect          = false
    dms                    = false
    documentdb             = false
    dynamodb               = false
    ebs                    = true
    ec2                    = true
    ec2api                 = true
    ec2spot                = true
    ecs                    = false
    efs                    = false
    elasticache            = false
    elasticbeanstalk       = false
    elasticinference       = false
    elastictranscoder      = false
    elb                    = false
    emr                    = false
    es                     = false
    firehose               = false
    gamelift               = false
    glue                   = false
    inspector              = false
    iot                    = false
    kinesis                = false
    kinesis_analytics      = false
    kms                    = false
    lambda                 = false
    lex                    = false
    mediaconnect           = false
    mediaconvert           = false
    mediapackage           = false
    mediatailor            = false
    ml                     = false
    mq                     = false
    msk                    = false
    nat_gateway            = true
    neptune                = false
    network_elb            = false
    networkfirewall        = false
    opsworks               = false
    polly                  = false
    rds                    = true
    redshift               = false
    rekognition            = false
    route53                = true
    route53resolver        = false
    s3                     = true
    sagemaker              = false
    ses                    = true
    shield                 = false
    sns                    = false
    sqs                    = false
    step_functions         = false
    storage_gateway        = false
    swf                    = false
    transitgateway         = false
    translate              = false
    trusted_advisor        = false
    usage                  = true
    vpn                    = false
    waf                    = false
    wafv2                  = false
    workspaces             = false
    xray                   = false
  }
  excluded_regions = [
    "us-east-1",
    "us-east-2"
  ]
}
