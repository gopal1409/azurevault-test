#all the default region which is dev test or stagin area
provider "azurerm" {
  features {
    virtual_machine {
      #delete_os_disk_on_deletion = false 
    }
  }
  
}



##when i delete a vm in azure the storage get deleted. os disk get delete
###there are secnarion where i dont want os disk get deleted
###terraform required provider block
###if i do first time terraform init. 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "2.78.0"
    }
    random = {
      source = "hashicorp/random"
    }
    #client_id = "12c0db5b-d8ec-4d6b-b79b-6c5d5fa8153b"
  #client_secret = SnG8Q~VHHrntQixG1s_B8owWqgIDIelykW31wdmw
  #environment = "eastus"
  #subscription_id = 12c0db5b-d8ec-4d6b-b79b-6c5d5fa8153b
  }
  
}
