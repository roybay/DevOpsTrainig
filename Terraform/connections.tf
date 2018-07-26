provider "google" {
  credentials = "${file("../../account.json")}"
  project     = "rbahian-project"
  region      = "us-east1"
}

/* 
Go to terminal 
aws configure
AWS access key required


provider "aws" {
	region = "us-east-1"
}
*/

/* azure account has not been configured. However, it has default configuration to download the plugins. */
provider "azurerm" {
  sebscription_id = "0"
  client_id       = "1"
  client_secret   = "2"
  tenent_id       = "3"
}
