resource "random_password" "vm_password" {
  length = 16
  special = true
  override_special = "!#$%&,."
}
resource "azurerm_key_vault_secret" "kv-vm-secret" {
  key_vault_id = azurerm_key_vault.kv.id 
  name = var.kv_name
  value = random_password.vm_password.result
}