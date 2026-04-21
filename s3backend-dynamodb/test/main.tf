resource "null_resource" "motto" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "echo ${var.message}"
  }
}
