# # YOUR OUTPUT(S)

output "jenkins-demo-public-ip" {
    value = azurerm_public_ip.main.ip_address
    depends_on = [
      azurerm_public_ip.main
    ]
}