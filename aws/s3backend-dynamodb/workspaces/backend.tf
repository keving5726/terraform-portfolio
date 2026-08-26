terraform {
  backend "s3" {
    bucket       = ""
    key          = ""
    encrypt      = true
    use_lockfile = false

    region = ""

    dynamodb_table = ""

    assume_role = {
      role_arn = ""
    }
  }
}
