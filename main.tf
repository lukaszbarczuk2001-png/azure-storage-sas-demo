resource "azurerm_resource_group" "main" {
  name     = "rg-storage-demo"
  location = "polandcentral"
}

resource "azurerm_storage_account" "main" {
  name                     = "stdemo29072026"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "main" {
  name                  = "demo-files"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
resource "azurerm_storage_blob" "demo_file" {
  name                   = "demo.txt"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type                   = "Block"
  source                 = "demo.txt"
}

data "azurerm_storage_account_blob_container_sas" "demo" {
  connection_string = azurerm_storage_account.main.primary_connection_string
  container_name     = azurerm_storage_container.main.name

  start  = "2026-07-29T00:00:00Z"
  expiry = "2026-07-30T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = true
  }
}
output "sas_url" {
  value     = "${azurerm_storage_blob.demo_file.url}?${data.azurerm_storage_account_blob_container_sas.demo.sas}"
  sensitive = true
}