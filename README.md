# GCP DNS forwarder

Following repository contains [Packer](https://www.packer.io/) template for
creating [Compute Engine image](https://cloud.google.com/compute/docs/images)
with [BIND](https://www.isc.org/bind) based DNS forwarder. Image is based on Centos 8 Linux OS.

---

## Use case

Primary use case for custom DNS forwarder is situation when using
[Cloud DNS forwarding zones](https://cloud.google.com/dns/docs/overview#dns-forwarding-methods)
to forward DNS request towards target servers is not possible.

Example of such situation is hybrid cloud scenario in which there is on-premisses DNS server.
In this scenario it is required to resolve on-premisses hostnames from GCP VPCs (using on-premisses
DNS server).

Normally such requirement can be satisfied with [Cloud DNS forwarding zones](https://cloud.google.com/dns/docs/overview#dns-forwarding-methods).
However lets assume situation that connectivity from public ip range 35.199.192.0/19, used by CloudDNS
as a source of forwarded DNS requests, is not allowed towards on-premisses network. It is required
that all originating connections should use RFC 1918 address space instead.
