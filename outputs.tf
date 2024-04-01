output "virtual_network_name" {
  value = azurerm_virtual_network.clalit-vn
}

output "clalit-storage-account" {
    value = azurerm_storage_account.clalit-storage-account.id
  
}
