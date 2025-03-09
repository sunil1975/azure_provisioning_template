resource "local_file" "file" {
  content  = var.content
  filename = "/tmp/hi.txt"
}