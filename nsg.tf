
resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "nsg-sg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
  #depends_on = [azurerm_network_security_rule.web_subnet_nsg_rule]
  #untile the nsg will cresate it will not assicate the rule
  subnet_id                 = azurerm_subnet.subnnet.id 
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}
locals {
  web_inbound_port = {
    ###in local the separtion of key and value is being done using == sign
    ###if your key is numerics use colon. 
    "110" : "80",
    "120" : "443",
    "130" : "22"
  }
}
##nsg inbound rule 
resource "azurerm_network_security_rule" "web_subnet_nsg_rule" {
  for_each                    = local.web_inbound_port
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}

