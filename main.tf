terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-playground-tfstate-bucket-rsakon"
    key     = "terraform-playground-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

# Cloud Front用
provider "aws" {
  alias   = "virginia"
  profile = "terraform"
  region  = "us-east-1"
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "domain" {
  type = string
}