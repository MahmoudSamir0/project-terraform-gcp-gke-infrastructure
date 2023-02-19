# project-terraform-gcp-gke-infrastructure
![lab](https://github.com/MahmoudSamir0/terraform-gcp-gke-infrastructure/blob/master/screenshot/w.png)

![final](https://github.com/MahmoudSamir0/terraform-gcp-gke-infrastructure/blob/master/screenshot/Screenshot%20from%202023-02-14%2010-00-21.png)

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The Compute Engine and Kubernetes Engine APIs are [active](#enable-apis) on the project you will launch the cluster in.

### Software Dependencies
#### Kubectl
- [kubectl](https://kubernetes.io/docs/tasks/tools)

#### Terraform and Plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.13+
- [Terraform Provider for GCP][terraform-provider-google] v4.51
- 
#### gcloud
- assumes you already have gcloud installed in your $PATH.

### Enable APIs

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
[12.3.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/12.3.0
[terraform-0.13-upgrade]: https://www.terraform.io/upgrade-guides/0-13.html


## Before you do anything in this module

 run following commands in your local machine:

```shell script
sudo apt update
```
## Configure Docker & gcloud to work with GCR of your project
1. run following command  to login in your cli 
  ```shell script
  gcloud auth login
  ```
2. be sure that you have install docker 
- [docker](https://docs.docker.com/engine/install/)

3.  to use docker without sudo 
  ```shell script
 sudo usermod -a -G docker ${USER}
```
4.
  ```shell script
 VERSION=2.1.5
OS=linux  # or "darwin" for OSX, "windows" for Windows.
ARCH=amd64  # or "386" for 32-bit OSs, "arm64" for ARM 64.

curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" \
| tar xz docker-credential-gcr \
&& chmod +x docker-credential-gcr && sudo mv docker-credential-gcr /usr/bin/
```
  ```shell script

gcloud auth configure-docker
```


## to build your app and dockerize it 
- clone this repo 
 ```shell script
git clone https://github.com/MahmoudSamir0/terraform-gcp-gke-infrastructure.git
```
- enter the file of repo

```shell script
  cd terraform-gcp-gke-infrastructure
```
- enter the file of app

```shell script
  cd dockerized_app
```

- build the app

```shell script
docker build -t gcr.io/<project-id>/final_app .
```
```shell script
docker image ls
```
- push it to your container repo in gcp
```shell script
docker push gcr.io/<project-id>/final_app
```
- back to your main file 
```shell script
cd ..
```
## your image is ready

## Build infrastructure

### Terraform

Terraform is already installed in your Cloud Shell environment. You can verify
this by running `terraform version`.

```shell script
terraform version
```

**Note:** When you run `terraform version`, Terraform may print a warning that
  there is a newer version of Terraform available. This tutorial has been tested
  with the version of Terraform installed in your Cloud Shell environment, so
  you can continue to use it for the rest of the tutorial.
  
  ### Initialize the directory

When you create a new configuration — or check out an existing configuration
from version control — you need to initialize the directory with `terraform
init`. This step downloads the providers defined in the configuration.

Initialize the directory.

```shell script
terraform init
```

Terraform returns output similar to the following.

```raw
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/google from the dependency lock file
- Using previously-installed hashicorp/google v4.53.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Terraform downloads the `google` provider and installs it in a hidden
subdirectory of your current working directory, named `.terraform`. The
`terraform init` command prints the provider version Terraform installed.
Terraform also creates a lock file named `.terraform.lock.hcl`, which specifies
the exact provider versions used to ensure that every Terraform run is
consistent. This also allows you to control when you want to upgrade the
providers used in your configuration

### Apply Configuration

```shell script
terraform apply 
```
- Terraform will print output similar to what is shown below. We have truncated some of the output for brevity.
- Terraform will prompt you to confirm the operation.

```raw
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.k8s.google_compute_firewall.final-egress will be created
  + resource "google_compute_firewall" "final-egress" {
      + creation_timestamp = (known after apply)
      + destination_ranges = [
          + "0.0.0.0/0",
        ]
      + direction          = "EGRESS"
      + enable_logging     = (known after apply)
      + id                 = (known after apply)
      + name               = "managementegress"
      + network            = "final-task-vpc"
      + priority           = 1000
      + project            = (known after apply)
      + self_link          = (known after apply)
      + target_tags        = [
          + "management1subnet1instance",
        ]

      + allow {
          + ports    = []
          + protocol = "all"
        }
    }

  # module.k8s.google_compute_firewall.final-egress-deny will be created
  + resource "google_compute_firewall" "final-egress-deny" {
      + creation_timestamp = (known after apply)
      + destination_ranges = [
          + "0.0.0.0/0",
        ]
      + direction          = "EGRESS"
      + enable_logging     = (known after apply)
      + id                 = (known after apply)
      + name               = "restricted1egress"
      + network            = "final-task-vpc"
      + priority           = 1000
      + project            = (known after apply)
      + self_link          = (known after apply)
      + target_tags        = [
          + "restricted1subnet1gke",
        ]

      + deny {
          + ports    = []
          + protocol = "all"
        }
    }

  # module.k8s.google_compute_firewall.ingress-restricted_subnet will be created
  + resource "google_compute_firewall" "ingress-restricted_subnet" {
      + creation_timestamp = (known after apply)
      + destination_ranges = (known after apply)
      + direction          = "INGRESS"
      + enable_logging     = (known after apply)
      + id                 = (known after apply)
      + name               = "ingress1restricted"
      + network            = "final-task-vpc"
      + priority           = 1000
      + project            = (known after apply)
      + self_link          = (known after apply)
      + source_ranges      = [
          + "10.0.8.0/24",
        ]

      + allow {
          + ports    = []
          + protocol = "all"
        }
    }

  # module.k8s.google_compute_firewall.ingress_management_subnet will be created
  + resource "google_compute_firewall" "ingress_management_subnet" {
      + creation_timestamp = (known after apply)
      + destination_ranges = (known after apply)
      + direction          = "INGRESS"
      + enable_logging     = (known after apply)
      + id                 = (known after apply)
      + name               = "ingress1management"
      + network            = "final-task-vpc"
      + priority           = 1000
      + project            = (known after apply)
      + self_link          = (known after apply)
      + source_ranges      = [
          + "0.0.0.0/0",
        ]
      + target_tags        = [
          + "management1subnet1instance",
        ]

      + allow {
          + ports    = []
          + protocol = "all"
        }
    }

  # module.k8s.google_compute_instance.private_vm will be created
  + resource "google_compute_instance" "private_vm" {
      + can_ip_forward       = false
      + cpu_platform         = (known after apply)
      + current_status       = (known after apply)
      + deletion_protection  = false
      + guest_accelerator    = (known after apply)
      + id                   = (known after apply)
      + instance_id          = (known after apply)
      + label_fingerprint    = (known after apply)
      + machine_type         = "f1-micro"
      + metadata_fingerprint = (known after apply)
      + min_cpu_platform     = (known after apply)
      + name                 = "privatevm"
      + project              = (known after apply)
      + self_link            = (known after apply)
      + tags                 = [
          + "management1subnet1instance",
        ]
      + tags_fingerprint     = (known after apply)
      + zone                 = "us-west1-b"

      + boot_disk {
          + auto_delete                = true
          + device_name                = (known after apply)
          + disk_encryption_key_sha256 = (known after apply)
          + kms_key_self_link          = (known after apply)
          + mode                       = "READ_WRITE"
          + source                     = (known after apply)

          + initialize_params {
              + image  = "debian-cloud/debian-11"
              + labels = (known after apply)
              + size   = (known after apply)
              + type   = (known after apply)
            }
        }

      + confidential_instance_config {
          + enable_confidential_compute = (known after apply)
        }

      + network_interface {
          + ipv6_access_type   = (known after apply)
          + name               = (known after apply)
          + network            = "final-task-vpc"
          + network_ip         = (known after apply)
          + stack_type         = (known after apply)
          + subnetwork         = "managementsubnet"
          + subnetwork_project = (known after apply)
        }

      + reservation_affinity {
          + type = (known after apply)

          + specific_reservation {
              + key    = (known after apply)
              + values = (known after apply)
            }
        }

      + scheduling {
          + automatic_restart           = (known after apply)
          + instance_termination_action = (known after apply)
          + min_node_cpus               = (known after apply)
          + on_host_maintenance         = (known after apply)
          + preemptible                 = (known after apply)
          + provisioning_model          = (known after apply)

          + node_affinities {
              + key      = (known after apply)
              + operator = (known after apply)
              + values   = (known after apply)
            }
        }

      + service_account {
          + email  = (known after apply)
          + scopes = [
              + "https://www.googleapis.com/auth/cloud-platform",
            ]
        }
    }

  # module.k8s.google_compute_network.vpc_network will be created
  + resource "google_compute_network" "vpc_network" {
      + auto_create_subnetworks         = false
      + delete_default_routes_on_create = false
      + gateway_ipv4                    = (known after apply)
      + id                              = (known after apply)
      + internal_ipv6_range             = (known after apply)
      + mtu                             = (known after apply)
      + name                            = "final-task-vpc"
      + project                         = (known after apply)
      + routing_mode                    = (known after apply)
      + self_link                       = (known after apply)
    }

  # module.k8s.google_compute_router.router will be created
  + resource "google_compute_router" "router" {
      + creation_timestamp = (known after apply)
      + id                 = (known after apply)
      + name               = "my-router"
      + network            = (known after apply)
      + project            = (known after apply)
      + region             = "us-west1"
      + self_link          = (known after apply)
    }

  # module.k8s.google_compute_router_nat.nat will be created
  + resource "google_compute_router_nat" "nat" {
      + enable_dynamic_port_allocation      = (known after apply)
      + enable_endpoint_independent_mapping = true
      + icmp_idle_timeout_sec               = 30
      + id                                  = (known after apply)
      + name                                = "mynat"
      + nat_ip_allocate_option              = "AUTO_ONLY"
      + project                             = (known after apply)
      + region                              = "us-west1"
      + router                              = "my-router"
      + source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
      + tcp_established_idle_timeout_sec    = 1200
      + tcp_time_wait_timeout_sec           = 120
      + tcp_transitory_idle_timeout_sec     = 30
      + udp_idle_timeout_sec                = 30
    }

  # module.k8s.google_compute_subnetwork.management_subnet will be created
  + resource "google_compute_subnetwork" "management_subnet" {
      + creation_timestamp         = (known after apply)
      + external_ipv6_prefix       = (known after apply)
      + fingerprint                = (known after apply)
      + gateway_address            = (known after apply)
      + id                         = (known after apply)
      + ip_cidr_range              = "10.0.8.0/24"
      + ipv6_cidr_range            = (known after apply)
      + name                       = "managementsubnet"
      + network                    = (known after apply)
      + private_ip_google_access   = (known after apply)
      + private_ipv6_google_access = (known after apply)
      + project                    = (known after apply)
      + purpose                    = (known after apply)
      + region                     = "us-west1"
      + secondary_ip_range         = (known after apply)
      + self_link                  = (known after apply)
      + stack_type                 = (known after apply)
    }

  # module.k8s.google_compute_subnetwork.restricted_subnet will be created
  + resource "google_compute_subnetwork" "restricted_subnet" {
      + creation_timestamp         = (known after apply)
      + external_ipv6_prefix       = (known after apply)
      + fingerprint                = (known after apply)
      + gateway_address            = (known after apply)
      + id                         = (known after apply)
      + ip_cidr_range              = "10.0.7.0/24"
      + ipv6_cidr_range            = (known after apply)
      + name                       = "restricted1subnet"
      + network                    = (known after apply)
      + private_ip_google_access   = true
      + private_ipv6_google_access = (known after apply)
      + project                    = (known after apply)
      + purpose                    = (known after apply)
      + region                     = "us-west2"
      + secondary_ip_range         = [
          + {
              + ip_cidr_range = "10.0.16.0/21"
              + range_name    = "k8s-pod-range"
            },
          + {
              + ip_cidr_range = "10.0.48.0/21"
              + range_name    = "k8s-service-range"
            },
        ]
      + self_link                  = (known after apply)
      + stack_type                 = (known after apply)
    }

  # module.k8s.google_container_cluster.my-cluster will be created
  + resource "google_container_cluster" "my-cluster" {
      + cluster_ipv4_cidr           = (known after apply)
      + datapath_provider           = (known after apply)
      + default_max_pods_per_node   = (known after apply)
      + enable_binary_authorization = false
      + enable_intranode_visibility = (known after apply)
      + enable_kubernetes_alpha     = false
      + enable_l4_ilb_subsetting    = false
      + enable_legacy_abac          = false
      + enable_shielded_nodes       = true
      + endpoint                    = (known after apply)
      + id                          = (known after apply)
      + initial_node_count          = 1
      + label_fingerprint           = (known after apply)
      + location                    = "us-west2-a"
      + logging_service             = (known after apply)
      + master_version              = (known after apply)
      + monitoring_service          = (known after apply)
      + name                        = "my-gke-cluster"
      + network                     = (known after apply)
      + networking_mode             = (known after apply)
      + node_locations              = (known after apply)
      + node_version                = (known after apply)
      + operation                   = (known after apply)
      + private_ipv6_google_access  = (known after apply)
      + project                     = (known after apply)
      + remove_default_node_pool    = true
      + self_link                   = (known after apply)
      + services_ipv4_cidr          = (known after apply)
      + subnetwork                  = (known after apply)
      + tpu_ipv4_cidr_block         = (known after apply)

      + addons_config {
          + cloudrun_config {
              + disabled           = (known after apply)
              + load_balancer_type = (known after apply)
            }

          + config_connector_config {
              + enabled = (known after apply)
            }

          + dns_cache_config {
              + enabled = (known after apply)
            }

          + gce_persistent_disk_csi_driver_config {
              + enabled = (known after apply)
            }

          + gcp_filestore_csi_driver_config {
              + enabled = (known after apply)
            }

          + gke_backup_agent_config {
              + enabled = (known after apply)
            }

          + horizontal_pod_autoscaling {
              + disabled = (known after apply)
            }

          + http_load_balancing {
              + disabled = (known after apply)
            }

          + network_policy_config {
              + disabled = (known after apply)
            }
        }

      + authenticator_groups_config {
          + security_group = (known after apply)
        }

      + cluster_autoscaling {
          + enabled = (known after apply)

          + auto_provisioning_defaults {
              + boot_disk_kms_key = (known after apply)
              + disk_size         = (known after apply)
              + disk_type         = (known after apply)
              + image_type        = (known after apply)
              + min_cpu_platform  = (known after apply)
              + oauth_scopes      = (known after apply)
              + service_account   = (known after apply)

              + management {
                  + auto_repair     = (known after apply)
                  + auto_upgrade    = (known after apply)
                  + upgrade_options = (known after apply)
                }

              + shielded_instance_config {
                  + enable_integrity_monitoring = (known after apply)
                  + enable_secure_boot          = (known after apply)
                }

              + upgrade_settings {
                  + max_surge       = (known after apply)
                  + max_unavailable = (known after apply)
                  + strategy        = (known after apply)

                  + blue_green_settings {
                      + node_pool_soak_duration = (known after apply)

                      + standard_rollout_policy {
                          + batch_node_count    = (known after apply)
                          + batch_percentage    = (known after apply)
                          + batch_soak_duration = (known after apply)
                        }
                    }
                }
            }

          + resource_limits {
              + maximum       = (known after apply)
              + minimum       = (known after apply)
              + resource_type = (known after apply)
            }
        }

      + confidential_nodes {
          + enabled = (known after apply)
        }

      + cost_management_config {
          + enabled = (known after apply)
        }

      + database_encryption {
          + key_name = (known after apply)
          + state    = (known after apply)
        }

      + default_snat_status {
          + disabled = (known after apply)
        }

      + ip_allocation_policy {
          + cluster_ipv4_cidr_block       = (known after apply)
          + cluster_secondary_range_name  = "k8s-pod-range"
          + services_ipv4_cidr_block      = (known after apply)
          + services_secondary_range_name = "k8s-service-range"
        }

      + logging_config {
          + enable_components = (known after apply)
        }

      + master_auth {
          + client_certificate     = (known after apply)
          + client_key             = (sensitive value)
          + cluster_ca_certificate = (known after apply)

          + client_certificate_config {
              + issue_client_certificate = (known after apply)
            }
        }

      + master_authorized_networks_config {
          + gcp_public_cidrs_access_enabled = (known after apply)

          + cidr_blocks {
              + cidr_block   = "10.0.8.0/24"
              + display_name = "my_cidr"
            }
        }

      + mesh_certificates {
          + enable_certificates = (known after apply)
        }

      + monitoring_config {
          + enable_components = (known after apply)

          + managed_prometheus {
              + enabled = (known after apply)
            }
        }

      + network_policy {
          + enabled = true
        }

      + node_config {
          + boot_disk_kms_key = (known after apply)
          + disk_size_gb      = (known after apply)
          + disk_type         = (known after apply)
          + guest_accelerator = (known after apply)
          + image_type        = (known after apply)
          + labels            = (known after apply)
          + local_ssd_count   = (known after apply)
          + logging_variant   = (known after apply)
          + machine_type      = (known after apply)
          + metadata          = (known after apply)
          + min_cpu_platform  = (known after apply)
          + node_group        = (known after apply)
          + oauth_scopes      = (known after apply)
          + preemptible       = (known after apply)
          + resource_labels   = (known after apply)
          + service_account   = (known after apply)
          + spot              = (known after apply)
          + tags              = (known after apply)
          + taint             = (known after apply)

          + gcfs_config {
              + enabled = (known after apply)
            }

          + gvnic {
              + enabled = (known after apply)
            }

          + kubelet_config {
              + cpu_cfs_quota        = (known after apply)
              + cpu_cfs_quota_period = (known after apply)
              + cpu_manager_policy   = (known after apply)
            }

          + linux_node_config {
              + sysctls = (known after apply)
            }

          + reservation_affinity {
              + consume_reservation_type = (known after apply)
              + key                      = (known after apply)
              + values                   = (known after apply)
            }

          + shielded_instance_config {
              + enable_integrity_monitoring = (known after apply)
              + enable_secure_boot          = (known after apply)
            }

          + workload_metadata_config {
              + mode = (known after apply)
            }
        }

      + node_pool {
          + initial_node_count          = (known after apply)
          + instance_group_urls         = (known after apply)
          + managed_instance_group_urls = (known after apply)
          + max_pods_per_node           = (known after apply)
          + name                        = (known after apply)
          + name_prefix                 = (known after apply)
          + node_count                  = (known after apply)
          + node_locations              = (known after apply)
          + version                     = (known after apply)

          + autoscaling {
              + location_policy      = (known after apply)
              + max_node_count       = (known after apply)
              + min_node_count       = (known after apply)
              + total_max_node_count = (known after apply)
              + total_min_node_count = (known after apply)
            }

          + management {
              + auto_repair  = (known after apply)
              + auto_upgrade = (known after apply)
            }

          + network_config {
              + create_pod_range     = (known after apply)
              + enable_private_nodes = (known after apply)
              + pod_ipv4_cidr_block  = (known after apply)
              + pod_range            = (known after apply)
            }

          + node_config {
              + boot_disk_kms_key = (known after apply)
              + disk_size_gb      = (known after apply)
              + disk_type         = (known after apply)
              + guest_accelerator = (known after apply)
              + image_type        = (known after apply)
              + labels            = (known after apply)
              + local_ssd_count   = (known after apply)
              + logging_variant   = (known after apply)
              + machine_type      = (known after apply)
              + metadata          = (known after apply)
              + min_cpu_platform  = (known after apply)
              + node_group        = (known after apply)
              + oauth_scopes      = (known after apply)
              + preemptible       = (known after apply)
              + resource_labels   = (known after apply)
              + service_account   = (known after apply)
              + spot              = (known after apply)
              + tags              = (known after apply)
              + taint             = (known after apply)

              + gcfs_config {
                  + enabled = (known after apply)
                }

              + gvnic {
                  + enabled = (known after apply)
                }

              + kubelet_config {
                  + cpu_cfs_quota        = (known after apply)
                  + cpu_cfs_quota_period = (known after apply)
                  + cpu_manager_policy   = (known after apply)
                }

              + linux_node_config {
                  + sysctls = (known after apply)
                }

              + reservation_affinity {
                  + consume_reservation_type = (known after apply)
                  + key                      = (known after apply)
                  + values                   = (known after apply)
                }

              + shielded_instance_config {
                  + enable_integrity_monitoring = (known after apply)
                  + enable_secure_boot          = (known after apply)
                }

              + workload_metadata_config {
                  + mode = (known after apply)
                }
            }

          + placement_policy {
              + type = (known after apply)
            }

          + upgrade_settings {
              + max_surge       = (known after apply)
              + max_unavailable = (known after apply)
              + strategy        = (known after apply)

              + blue_green_settings {
                  + node_pool_soak_duration = (known after apply)

                  + standard_rollout_policy {
                      + batch_node_count    = (known after apply)
                      + batch_percentage    = (known after apply)
                      + batch_soak_duration = (known after apply)
                    }
                }
            }
        }

      + node_pool_defaults {
          + node_config_defaults {
              + logging_variant = (known after apply)
            }
        }

      + notification_config {
          + pubsub {
              + enabled = (known after apply)
              + topic   = (known after apply)

              + filter {
                  + event_type = (known after apply)
                }
            }
        }

      + private_cluster_config {
          + enable_private_endpoint = true
          + enable_private_nodes    = true
          + master_ipv4_cidr_block  = "10.0.11.0/28"
          + peering_name            = (known after apply)
          + private_endpoint        = (known after apply)
          + public_endpoint         = (known after apply)

          + master_global_access_config {
              + enabled = true
            }
        }

      + release_channel {
          + channel = (known after apply)
        }

      + service_external_ips_config {
          + enabled = (known after apply)
        }

      + vertical_pod_autoscaling {
          + enabled = (known after apply)
        }

      + workload_identity_config {
          + workload_pool = (known after apply)
        }
    }

  # module.k8s.google_container_node_pool.primary_preemptible_nodes will be created
  + resource "google_container_node_pool" "primary_preemptible_nodes" {
      + cluster                     = "my-gke-cluster"
      + id                          = (known after apply)
      + initial_node_count          = (known after apply)
      + instance_group_urls         = (known after apply)
      + location                    = "us-west2-a"
      + managed_instance_group_urls = (known after apply)
      + max_pods_per_node           = (known after apply)
      + name                        = "my-task-node-pool"
      + name_prefix                 = (known after apply)
      + node_count                  = 1
      + node_locations              = (known after apply)
      + operation                   = (known after apply)
      + project                     = (known after apply)
      + version                     = (known after apply)

      + management {
          + auto_repair  = (known after apply)
          + auto_upgrade = (known after apply)
        }

      + network_config {
          + create_pod_range     = (known after apply)
          + enable_private_nodes = (known after apply)
          + pod_ipv4_cidr_block  = (known after apply)
          + pod_range            = (known after apply)
        }

      + node_config {
          + disk_size_gb      = (known after apply)
          + disk_type         = (known after apply)
          + guest_accelerator = (known after apply)
          + image_type        = (known after apply)
          + labels            = (known after apply)
          + local_ssd_count   = (known after apply)
          + logging_variant   = "DEFAULT"
          + machine_type      = "e2-medium"
          + metadata          = (known after apply)
          + min_cpu_platform  = (known after apply)
          + oauth_scopes      = [
              + "https://www.googleapis.com/auth/cloud-platform",
            ]
          + preemptible       = true
          + service_account   = (known after apply)
          + spot              = false
          + taint             = (known after apply)

          + shielded_instance_config {
              + enable_integrity_monitoring = (known after apply)
              + enable_secure_boot          = (known after apply)
            }

          + workload_metadata_config {
              + mode = (known after apply)
            }
        }

      + upgrade_settings {
          + max_surge       = (known after apply)
          + max_unavailable = (known after apply)
          + strategy        = (known after apply)

          + blue_green_settings {
              + node_pool_soak_duration = (known after apply)

              + standard_rollout_policy {
                  + batch_node_count    = (known after apply)
                  + batch_percentage    = (known after apply)
                  + batch_soak_duration = (known after apply)
                }
            }
        }
    }

  # module.k8s.google_project_iam_member.compute_service will be created
  + resource "google_project_iam_member" "compute_service" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + member  = (known after apply)
      + project = (known after apply)
      + role    = "roles/container.admin"
    }

  # module.k8s.google_project_iam_member.role_gke will be created
  + resource "google_project_iam_member" "role_gke" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + member  = (known after apply)
      + project = (known after apply)
      + role    = "roles/storage.objectViewer"
    }

  # module.k8s.google_service_account.default will be created
  + resource "google_service_account" "default" {
      + account_id   = "virtualservice"
      + disabled     = false
      + display_name = "Service Account"
      + email        = (known after apply)
      + id           = (known after apply)
      + member       = (known after apply)
      + name         = (known after apply)
      + project      = (known after apply)
      + unique_id    = (known after apply)
    }

  # module.k8s.google_service_account.myservice-account-gke will be created
  + resource "google_service_account" "myservice-account-gke" {
      + account_id   = "service"
      + disabled     = false
      + display_name = "myservice-account-gke"
      + email        = (known after apply)
      + id           = (known after apply)
      + member       = (known after apply)
      + name         = (known after apply)
      + project      = (known after apply)
      + unique_id    = (known after apply)
    }

Plan: 16 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

```
answer `yes` to the confirmation prompt.

## now your infrastructure is ready 

## connect to your private instance using ssh

 ```shell script
 gcloud compute ssh --zone "<zone of your instance>" "<instance id>" --tunnel-through-iap --project "<project id>"
```

## you are now in your private machine

install kubetcl 
- [kubectl](https://kubernetes.io/docs/tasks/tools)


- install google-cloud-sdk-gke-gcloud-auth-plugin 

```shell script
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```
### connect to your cluster

```shell script
gcloud container clusters get-credentials <cluster name> --zone <zone> --project <project id>
```
you will get this massage 

```
Fetching cluster endpoint and auth data.
kubeconfig entry generated for <cluster name>.
```

-  show number of node uou have 

```shell script
kubectl get node
```
you will get this
 
```
NAME                                                 STATUS   ROLES    AGE     VERSION
gke-my-gke-cluster-my-task-node-pool-df43f273-zdp2   Ready    <none>   2m19s   v1.24.9-gke.2000

```

- now prepare your deployment files

```shell script
vim deploy.yml

```
 copy this in your deploy file ** change project id ** 
```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: final-app

  labels:

    app: final-app
    type: front-end

spec:

  replicas: 3

  selector:

    matchLabels:

      app: final-app
      type: front-end



  template:

    metadata:

      labels:

        app: final-app
        type: front-end


    spec:

      containers:

      - name: final-app

        image: gcr.io/<project-id>/final_app

        ports:

        - containerPort: 8000

      - name: db-redis

        image: redis

        ports:

        - containerPort: 6379

```
