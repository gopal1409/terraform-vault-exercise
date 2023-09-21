##when we do az login that time the tenat id is already configured you can call the same using data block

data "azurerm_client_config" "current" {}

resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  numeric = false   
}
resource "azurerm_resource_group" "rg" {
  name = "${var.env}-${var.rg_name}-${random_string.myrandom.id}"
  location = var.location
}

resource "random_id" "id" {
  byte_length = 4
}

resource "azurerm_key_vault" "kv" {
  name = "${var.env}-${var.rg_name}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name  
  location = azurerm_resource_group.rg.location
  ###when we create vault there is requirement where you need to provide the tenant id
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = var.kv_sku_name
  access_policy  {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = [
        "Set",
        "Get",
        "Delete",
        "Purge",
        "List"
    ]
  }
}

