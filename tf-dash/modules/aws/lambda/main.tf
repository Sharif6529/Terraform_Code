resource "aws_cloudwatch_log_group" "lambda_group" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 14
}
resource "aws_lambda_function" "this" {
  count = var.create && var.create_function && ! var.create_layer ? 1 : 0
  description   = var.description
  filename      = var.filename
  function_name = var.name
  #role          = aws_iam_role.lambda_exec_role[1].arn
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }
  dynamic "tracing_config" {
    for_each = var.tracing_mode == null ? [] : [true]
    content {
      mode = var.tracing_mode
    }
  }


  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids 
      subnet_ids         = var.vpc_subnet_ids
    }
  }
  tags = var.tags
}

  resource "aws_lambda_function_event_invoke_config" "this" {
  
  count = var.create && var.create_function ? 1 : 0

  function_name = aws_lambda_function.this[0].function_name
  #qualifier     = element(concat(aws_lambda_function.this.*.version, aws_lambda_alias.this.*.name, ["$LATEST"]), 0)

  dynamic "destination_config" {
    for_each = var.destination_on_failure != null || var.destination_on_success != null ? [true] : []
    content {
      dynamic "on_failure" {
        for_each = var.destination_on_failure != null ? [true] : []
        content {
          destination = var.destination_on_failure
        }
      }

      dynamic "on_success" {
        for_each = var.destination_on_success != null ? [true] : []
        content {
          destination = var.destination_on_success
        }
      }
    }
  }
}
resource "aws_lambda_event_source_mapping" "this" {
  for_each = var.create && var.create_function && !var.create_layer ? var.event_source_mapping : tomap({})

  function_name = aws_lambda_function.this[0].arn

  event_source_arn = each.value.event_source_arn

  batch_size                         = lookup(each.value, "batch_size", null)
  maximum_batching_window_in_seconds = lookup(each.value, "maximum_batching_window_in_seconds", null)
  enabled                            = lookup(each.value, "enabled", null)
  starting_position                  = lookup(each.value, "starting_position", null)
  starting_position_timestamp        = lookup(each.value, "starting_position_timestamp", null)
  parallelization_factor             = lookup(each.value, "parallelization_factor", null)
  maximum_retry_attempts             = lookup(each.value, "maximum_retry_attempts", null)
  maximum_record_age_in_seconds      = lookup(each.value, "maximum_record_age_in_seconds", null)
  bisect_batch_on_function_error     = lookup(each.value, "bisect_batch_on_function_error", null)


}
resource "aws_lambda_permission" "current_version_triggers" {
  for_each = var.create && var.create_function && ! var.create_layer ? var.allowed_triggers : {}

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = aws_lambda_function.this[0].version

  statement_id       = lookup(each.value, "statement_id", each.key)
  action             = lookup(each.value, "action", "lambda:InvokeFunction")
  principal          = lookup(each.value, "principal", format("%s.amazonaws.com", lookup(each.value, "service", "")))
  source_arn         = lookup(each.value, "source_arn", lookup(each.value, "service", null) == "apigateway" ? "${lookup(each.value, "arn", "")}/*/*/*" : null)
  source_account     = lookup(each.value, "source_account", null)
  event_source_token = lookup(each.value, "event_source_token", null)
}

##With lifecycle metadata
resource "aws_lambda_function" "lifecycle" {
  count = var.create_lifecycle ? 1 : 0
  description   = var.description
  filename      = var.filename
  function_name = var.name
   publish      = true
  #role          = aws_iam_role.lambda_exec_role[1].arn
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }


  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }
  /*lifecycle {
    ignore_changes = [environment]
  }*/
  tags = var.tags
}

  resource "aws_lambda_function_event_invoke_config" "lifecycle" {
  
  count = var.create_lifecycle ? 1 : 0

  function_name = aws_lambda_function.lifecycle[0].function_name
  #qualifier     = element(concat(aws_lambda_function.this.*.version, aws_lambda_alias.this.*.name, ["$LATEST"]), 0)

  dynamic "destination_config" {
    for_each = var.destination_on_failure != null || var.destination_on_success != null ? [true] : []
    content {
      dynamic "on_failure" {
        for_each = var.destination_on_failure != null ? [true] : []
        content {
          destination = var.destination_on_failure
        }
      }

      dynamic "on_success" {
        for_each = var.destination_on_success != null ? [true] : []
        content {
          destination = var.destination_on_success
        }
      }
    }
  }
}
resource "aws_lambda_event_source_mapping" "lifecycle" {
  for_each = var.create_lifecycle && !var.create_layer ? var.event_source_mapping : tomap({})

  function_name = aws_lambda_function.lifecycle[0].arn

  event_source_arn = each.value.event_source_arn

  batch_size                         = lookup(each.value, "batch_size", null)
  maximum_batching_window_in_seconds = lookup(each.value, "maximum_batching_window_in_seconds", null)
  enabled                            = lookup(each.value, "enabled", null)
  starting_position                  = lookup(each.value, "starting_position", null)
  starting_position_timestamp        = lookup(each.value, "starting_position_timestamp", null)
  parallelization_factor             = lookup(each.value, "parallelization_factor", null)
  maximum_retry_attempts             = lookup(each.value, "maximum_retry_attempts", null)
  maximum_record_age_in_seconds      = lookup(each.value, "maximum_record_age_in_seconds", null)
  bisect_batch_on_function_error     = lookup(each.value, "bisect_batch_on_function_error", null)

 #depends_on = [aws_lambda_function.lifecycle]
}
resource "aws_lambda_permission" "lifecycle_version_triggers" {
  for_each = var.create_lifecycle && !var.create_layer  ? var.allowed_triggers : {}

  function_name = aws_lambda_function.lifecycle[0].function_name
  #qualifier     = aws_lambda_function.this[0].version

  statement_id       = lookup(each.value, "statement_id", each.key)
  action             = lookup(each.value, "action", "lambda:InvokeFunction")
  principal          = lookup(each.value, "principal", format("%s.amazonaws.com", lookup(each.value, "service", "")))
  source_arn         = lookup(each.value, "source_arn", lookup(each.value, "service", null) == "apigateway" ? "${lookup(each.value, "arn", "")}/*/*/*" : null)
  source_account     = lookup(each.value, "source_account", null)
  event_source_token = lookup(each.value, "event_source_token", null)
}
