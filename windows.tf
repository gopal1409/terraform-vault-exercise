

resource "azurerm_virtual_network" "vnet" {
  
   name = "${var.env}-${var.rg_name}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name  
  location = azurerm_resource_group.rg.location
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  
  name = "${var.env}-${var.rg_name}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name  
  #location = azurerm_resource_group.rg.location
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "ni" {
  #name = "${var.env}-${var.rg_name}-ni"
   name = "${var.env}-${var.rg_name}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name  
  location = azurerm_resource_group.rg.location

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation="Dynamic"
  }
}
# Locals Block for custom data


# Resource: Azure Linux Virtual Machine
resource "azurerm_windows_virtual_machine" "web_linuxvm" {
  
   name = "${var.env}-${var.rg_name}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name  
  location = azurerm_resource_group.rg.location
  network_interface_ids = [ azurerm_network_interface.ni.id, ]
  size = "Standard_F2"
  admin_username = "adminuser"
  admin_password = azurerm_key_vault_secret.kv-vm-secret.value
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  #custom_data = filebase64("${path.module}/app-script/app-script.sh")    
  #custom_data = base64encode(local.webvm_custom_data)  

}