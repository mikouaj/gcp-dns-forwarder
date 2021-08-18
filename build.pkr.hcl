# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source "googlecompute" "centos-http-server" {
  project_id   = var.project_id
  zone         = var.compute_zone
  subnetwork   = var.compute_subnet
  ssh_username = "packer"
  tags         = ["ssh"]

  image_name          = "centos-8-dns-forwarder"
  source_image_family = "centos-8"
  image_description   = "BIND DNS forwarder"
}

build {
  sources = ["sources.googlecompute.centos-http-server"]
  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install bind -y",
      "sudo systemctl enable named"
    ]
  }
  provisioner "file" {
    source      = "named.conf"
    destination = "/tmp/named.conf"
  }
  provisioner "shell" {
    inline = [
      "sed -i 's/$TARGET_DNS_SERVER/${var.target_dns_server};/g' /tmp/named.conf"
    ]
  }
  provisioner "shell" {
    inline = [
      "sudo mv /tmp/named.conf /etc/named.conf",
      "sudo chown root:named /etc/named.conf",
      "sudo chmod 640 /etc/named.conf",
      "sudo systemctl start named"
    ]
  }
}
