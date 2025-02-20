output "face_client_sg_id" {
  value = aws_security_group.face_client_sg.id
}

output "web_server_sg_id" {
  value = aws_security_group.web_server_sg.id
}

output "face_client_sg_name" {
  value = aws_security_group.face_client_sg.name
}

output "web_server_sg_name" {
  value = aws_security_group.web_server_sg.name
}



