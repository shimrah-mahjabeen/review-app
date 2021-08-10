

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


# ============== Monitor host rules ==============

resource "datadog_monitor" "host" {
  name               = "EC2 host connectivity"
  type               = "service check"
  query              = "\"datadog.agent.up\".over(\"*\").by(\"host\").last(2).count_by_status()"
  enable_logs_sample = true
  locked             = false
  new_host_delay     = 300
  notify_no_data     = true
  notify_audit       = false
  priority           = 1
  no_data_timeframe  = 2
  renotify_interval  = 10
  include_tags       = true
  timeout_h          = 0
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in EC2 host connectivity. The host is {{host}}.   
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about EC2 host connectivity was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
EC2 host connection is not still recovered. We need to fix this ASAP.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}



# ============== Monitor application loadbalancer rules ==============


resource "datadog_monitor" "alb_healthy_host_count" {
  name                = "application loadbalancer healthy host count"
  type                = "metric alert"
  query               = "max(last_1h):avg:aws.applicationelb.healthy_host_count{datadog_flag:${var.name}} <= 0"
  enable_logs_sample  = true
  locked              = false
  notify_no_data      = true
  no_data_timeframe   = 10
  notify_audit        = false
  priority            = 1
  renotify_interval   = 30
  evaluation_delay    = 900
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical = 0
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in application loadbalancer healthy host count.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about application loadbalancer healthy host count was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of application loadbalancer healthy host count is not still recovered. We need to fix this ASAP.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "alb_unhealthy_host_count" {
  name                = "application loadbalancer unhealthy host count"
  type                = "metric alert"
  query               = "avg(last_15m):avg:aws.applicationelb.un_healthy_host_count{datadog_flag:${var.name}} >= 1"
  enable_logs_sample  = true
  locked              = false
  notify_no_data      = true
  no_data_timeframe   = 10
  notify_audit        = false
  priority            = 3
  renotify_interval   = 0
  evaluation_delay    = 900
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical = 1
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in application loadbalancer unhealthy host count.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about application loadbalancer unhealthy host count was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of application loadbalancer unhealthy host count is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "alb_http_code_4xx_count" {
  name                = "application loadbalancer http code 4xx count"
  type                = "query alert"
  query               = "sum(last_5m):avg:aws.applicationelb.httpcode_elb_4xx{datadog_flag:${var.name}}.as_count() > 100"
  enable_logs_sample  = true
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 3
  renotify_interval   = 0
  evaluation_delay    = 900
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 100
    warning           = 50
    warning_recovery  = 20
    critical_recovery = 20
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in application loadbalancer http code 4xx count.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about application loadbalancer http code 4xx count was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of application loadbalancer http code 4xx count is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "alb_http_code_5xx_count" {
  name                = "application loadbalancer http code 4xx count"
  type                = "query alert"
  query               = "sum(last_5m):avg:aws.applicationelb.httpcode_elb_5xx{datadog_flag:${var.name}}.as_count() > 100"
  enable_logs_sample  = true
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 3
  renotify_interval   = 0
  evaluation_delay    = 900
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 100
    warning           = 50
    warning_recovery  = 20
    critical_recovery = 20
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in application loadbalancer http code 5xx count.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about application loadbalancer http code 5xx count was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of application loadbalancer http code 5xx count is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "alb_target_response_time_99p" {
  name                = "application loadbalancer target response time 99p"
  type                = "metric alert"
  query               = "avg(last_1h):avg:aws.applicationelb.target_response_time.p99{datadog_flag:${var.name}} > 0.35"
  enable_logs_sample  = true
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 4
  renotify_interval   = 0
  evaluation_delay    = 900
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 0.35
    warning           = 0.3
    warning_recovery  = 0.2
    critical_recovery = 0.2
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in application loadbalancer target response time 99p.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about application loadbalancer target response time 99p was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of application loadbalancer target response time 99p is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}




# ============== Monitor rds ==============

resource "datadog_monitor" "rds_cpuutilization" {
  name                = "rds cpu utilication"
  type                = "metric alert"
  query               = "avg(last_5m):avg:aws.rds.cpuutilization{datadog_flag:${var.name}} > 50"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 3
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 50
    warning           = 30
    warning_recovery  = 25
    critical_recovery = 45
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in rds cpu utilication.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about rds cpu utilication was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of rds cpu utilication is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "rds_database_connections" {
  name                = "rds database connections"
  type                = "metric alert"
  query               = "avg(last_5m):avg:aws.rds.database_connections{datadog_flag:${var.name}} > 50"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 4
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 50
    critical_recovery = 30
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in rds database connections.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about rds database connections was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of rds database connections is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "rds_free_storage_space" {
  name                = "rds free storage space"
  type                = "metric alert"
  query               = "avg(last_5m):avg:aws.rds.free_storage_space{datadog_flag:${var.name}} <= 500000000"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 2
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 500000000
    warning           = 1000000000
    warning_recovery  = 1500000000
    critical_recovery = 800000000
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in rds free storage space.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about rds free storage space was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of rds free storage space is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "rds_freeable_memory" {
  name                = "rds freeable memory"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.mem.usable{datadog_flag:${var.name}} <= 200000000"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 3
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 200000000
    warning           = 400000000
    warning_recovery  = 600000000
    critical_recovery = 500000000
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in rds freeable memory.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about rds freeable memory was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of rds freeable memory is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}





# ============== Monitor s3 ==============

resource "datadog_monitor" "s3_bucket_size_bytes" {
  name                = "s3 bucket size bytes"
  type                = "metric alert"
  query               = "avg(last_5m):avg:aws.s3.bucket_size_bytes{datadog_flag:${var.name}} >= 10000000000"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 4
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical = 10000000000 // 10G
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in s3 bucket size bytes.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about s3 bucket size bytes was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of s3 bucket size bytes is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}




# ============== Monitor system rules ==============

resource "datadog_monitor" "system_user_cpu" {
  name                = "system user cpu"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.cpu.user{datadog_flag:${var.name}} >= 50"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 2
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 50
    warning           = 30
    warning_recovery  = 25
    critical_recovery = 45
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in system user cpu.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about system user cpu was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of system user cpu is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "system_user_system" {
  name                = "system user system"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.cpu.system{datadog_flag:${var.name}} >= 50"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 2
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 50
    warning           = 30
    warning_recovery  = 25
    critical_recovery = 45
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in system user cpu.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about system user cpu was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of system user cpu is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "system_cpu_iowait" {
  name                = "system cpu iowait"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.cpu.iowait{datadog_flag:${var.name}} >= 20"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 3
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 20
    warning           = 10
    warning_recovery  = 8
    critical_recovery = 15
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in system cpu iowait.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about system cpu iowait was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of system cpu iowait is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "system_fs_inode_in_use" {
  name                = "system fs inode in use"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.fs.inodes.in_use{datadog_flag:${var.name}} >= 50"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 2
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 50
    warning           = 40
    warning_recovery  = 30
    critical_recovery = 45
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in system fs inode in use.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about system fs inode in use was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of system fs inode in use is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "system_mem_usable" {
  name                = "system mem usable"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.mem.usable{datadog_flag:${var.name}} <= 200000000"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 2
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 200000000
    warning           = 300000000
    warning_recovery  = 400000000
    critical_recovery = 250000000
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in system mem usable.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about system mem usable was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of system mem usable is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "system_swap_used" {
  name                = "system swap used"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.swap.used{datadog_flag:${var.name}} >= 100000000"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 3
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 100000000
    critical_recovery = 10000000
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in system swap used.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about system swap used was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of system swap used is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}

resource "datadog_monitor" "system_disk_in_use" {
  name                = "system disk in use"
  type                = "metric alert"
  query               = "avg(last_5m):avg:system.disk.in_use{datadog_flag:${var.name}} >= 50"
  locked              = false
  notify_no_data      = false
  notify_audit        = false
  priority            = 2
  renotify_interval   = 0
  include_tags        = true
  require_full_window = true
  timeout_h           = 0
  monitor_thresholds {
    critical          = 50
    warning           = 40
    warning_recovery  = 30
    critical_recovery = 45
  }
  message            = <<EOF
{{#is_alert}}
${var.channel_name}  
There is an anomaly in system disk in use.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.  
{{/is_alert}}

{{#is_recovery}}
${var.channel_name}  
The alert about system disk in use was resolved!!  
{{/is_recovery}}
EOF
  escalation_message = <<EOF
${var.channel_name} 
The problem of system disk in use is not still recovered. It would be better to investigate the reason soon.  
If you are able to analyze and resolve, please chat for this alert message and then start to work on it.
EOF
}



# ============== Synthetics test ==============

resource "datadog_synthetics_test" "test_ssl" {
  type    = "api"
  subtype = "ssl"
  request_definition {
    host = "surveyhr.jp"
    port = 443
  }
  assertion {
    type     = "certificate"
    operator = "isInMoreThan"
    target   = 30
  }
  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = 2000
  }
  locations = ["aws:ap-northeast-1"]
  options_list {
    tick_every         = 300
    accept_self_signed = true
  }
  name    = "SSL test on surveyhr.jp"
  message = "${var.channel_name}  SSL test on surveyhr.jp failed"
  status  = "live"
}