resource "aws_cognito_user_pool" "pool" {
  name = var.userpool_name

  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]
  username_configuration {
    case_sensitive = false
  }
  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true
    string_attribute_constraints {
      max_length = 256
      min_length = 1
    }
  }
  schema {
    name                = "departmentNo"
    attribute_data_type = "String"
    mutable             = true
    required            = false
    string_attribute_constraints {
      max_length = 256
      min_length = 1
    }
  }
  schema {
    name                = "classNo"
    attribute_data_type = "String"
    mutable             = true
    required            = false
    string_attribute_constraints {
      max_length = 256
      min_length = 1
    }
  }
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
}

resource "aws_cognito_user_group" "superadmin" {
  name         = "superadmin"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_group" "faculty" {
  name         = "faculty"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_group" "student" {
  name         = "student"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "react" {
  name         = "react"
  user_pool_id = aws_cognito_user_pool.pool.id
}
