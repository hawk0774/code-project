# Bastion
resource "yandex_compute_instance" "bastion" {
   name                      = var.hostname
   hostname                  = var.hostname
   zone                      = var.new_zone
   platform_id               = var.platform
   allow_stopping_for_update = true
  
   resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

   boot_disk {
    disk_id  = "${yandex_compute_disk.disk-bastion.id}"
    }
  
  
   network_interface {
    subnet_id          = yandex_vpc_subnet.external-network.id
    nat                = true
      dns_record {
        fqdn = "bastion.local."
    ttl = 300
    }
    security_group_ids = [yandex_vpc_security_group.private-network.id, yandex_vpc_security_group.public-bastion-network.id]
    ip_address         = "10.10.4.4"
  }


   metadata = {
     user-data = "${file("./meta.txt")}"
  }

   scheduling_policy {  
      preemptible = false
   }
 }


# Webserv-1
resource "yandex_compute_instance" "webserv-1" {

  name            = var.web1-name
  hostname        = var.web1-name
  zone            = var.default_zone
  platform_id     = var.platform


  resources {
    cores         = 2
    core_fraction = 5
    memory        = 1
  }


  boot_disk {
    disk_id     = "${yandex_compute_disk.disk-webserv-1.id}"
    }
  
  
  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-web-1.id
      dns_record {
        fqdn = "webserv-1.local."
    ttl = 300
    }
    security_group_ids = [yandex_vpc_security_group.private-network.id]
     ip_address        = "10.10.1.3"
  }
  
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
  
  
  scheduling_policy {  
    preemptible = false
  }
}


#Webserv-2
resource "yandex_compute_instance" "webserv-2" {
  name                      = var.web2-name
  hostname                  = var.web2-name
  zone                      = var.new_zone
  platform_id               = var.platform
  allow_stopping_for_update = true

  resources {
    cores         = 2
    core_fraction = 5
    memory        = 1
  }


  boot_disk {
    disk_id     = "${yandex_compute_disk.disk-webserv-2.id}"
    }


  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-web-2.id
      dns_record {
        fqdn = "webserv-2.local."
    ttl = 300
    }
    security_group_ids = [yandex_vpc_security_group.private-network.id]
    ip_address        = "10.10.2.3"
  }
  
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
  
  
  scheduling_policy {  
    preemptible = false
  }
}

#Zabbix

resource "yandex_compute_instance" "zabbix" {
  name                      = var.zab-name
  hostname                  = var.zab-name
  zone                      = var.new_zone
  platform_id               = var.platform
  allow_stopping_for_update = true


  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }


  boot_disk {
    disk_id  = "${yandex_compute_disk.disk-zabbix.id}"
    }
 
 
  network_interface {
    subnet_id          = yandex_vpc_subnet.external-network.id
    nat                = true
      dns_record {
        fqdn = "zabbix.local."
    ttl = 300
    }
    security_group_ids = [yandex_vpc_security_group.private-network.id,yandex_vpc_security_group.external-zabbix.id]
    ip_address        = "10.10.4.5"
  }
  
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
  
  
  scheduling_policy {  
     preemptible = false
  }
}

#Elastic
resource "yandex_compute_instance" "elastic" {
  name                      = var.el-name
  hostname                  = var.el-name
  zone                      = var.new_zone
  platform_id               = var.platform
  allow_stopping_for_update = true


  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }


  boot_disk {
    disk_id     = "${yandex_compute_disk.disk-elastic.id}"
    }


  network_interface {
    subnet_id          = yandex_vpc_subnet.internal-network.id
      dns_record {
        fqdn = "elastic.local."
    ttl = 300
    }
    security_group_ids = [yandex_vpc_security_group.private-network.id]
    ip_address        = "10.10.3.4"
  }
  
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
  
  
  scheduling_policy {  
    preemptible = false
  }
}


#Kibana
resource "yandex_compute_instance" "kibana" {
  name                      = "kibana"
  hostname                  = "kibana"
  zone                      = var.new_zone
  platform_id               = var.platform
  allow_stopping_for_update = true

  
  resources {
    cores = 2
    core_fraction = 20
    memory = 6
  }


  boot_disk {
    disk_id   = "${yandex_compute_disk.disk-kibana.id}"
  }

    
  network_interface {
    subnet_id = yandex_vpc_subnet.external-network.id
    nat = true
      dns_record {
        fqdn = "kibana.local."
    ttl = 300
    }
    security_group_ids = [yandex_vpc_security_group.private-network.id, yandex_vpc_security_group.external-kibana.id]
    ip_address        = "10.10.4.3"
  }
  
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
  
  
  scheduling_policy {  
    preemptible = false
  }
}



