provider "google" {
    credentials = "${file(var.credentials)}"
    project     = "mattermost-245316"
    
}

