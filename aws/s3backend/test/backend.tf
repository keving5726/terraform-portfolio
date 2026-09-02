terraform {
  backend "s3" {
    bucket       = ""
    key          = ""
    encrypt      = true
    use_lockfile = true

    region = ""

    assume_role = {
      role_arn = ""
    }
  }
}
