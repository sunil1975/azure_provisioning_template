output "content" {
  value       = local_file.file.content
  sensitive   = false
  description = "description"
  depends_on  = []
}
