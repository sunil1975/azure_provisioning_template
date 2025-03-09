variables {
  content = "test content"
}

run "valid_string" {

  command = plan

  assert {
    condition     = local_file.file.content == "test content"
    error_message = "file content did not match"
  }

}

run "valid_filename" {

  command = plan

  assert {
    condition     = local_file.file.filename == "/tmp/hi.txt"
    error_message = "file should be stored in /tmp/hi.txt"
  }

}