terraform {
  required_version = ">=0.12.6"

  required_providers {
    google-beta = {
      version = ">= 3.32.0, <4.0.0"
    }

    kubernetes = {
      version = "~> 1.10, != 1.11.0" 
    } 
    
  }
}
