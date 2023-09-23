# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "aws_account" {
  description = "AWS Account Id"
  type        = string
  default     = "Enter your account id"
}
