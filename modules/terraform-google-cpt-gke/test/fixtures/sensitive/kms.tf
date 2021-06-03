locals {
  service_identities = { 
    "gke" = "service-${module.test_project.project_number}@container-engine-robot.iam.gserviceaccount.com"
    "gce" = "service-${module.test_project.project_number}@compute-system.iam.gserviceaccount.com"
  }
  kms_keys = {
    gke = {
        decrypters = [
            "serviceAccount:${local.service_identities["gce"]}",
            "serviceAccount:${local.service_identities["gke"]}"
        ]
        encrypters = [
            "serviceAccount:${local.service_identities["gce"]}",
            "serviceAccount:${local.service_identities["gke"]}"
        ]
    }
  }
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  for_each      = local.kms_keys
  crypto_key_id = google_kms_crypto_key.key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  members       = contains(keys(each.value), "encrypters") ? flatten(each.value["encrypters"]) : []
}

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  for_each      = local.kms_keys
  crypto_key_id = google_kms_crypto_key.key[each.key].id
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  members       = contains(keys(each.value), "decrypters") ? flatten(each.value["decrypters"]) : []
}

resource "google_kms_crypto_key_iam_binding" "encrypter_decrypter" {
  for_each      = local.kms_keys
  crypto_key_id = google_kms_crypto_key.key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = contains(keys(each.value), "encrypter_decrypter") ? flatten(each.value["encrypter_decrypter"]) : []
}

resource "google_kms_key_ring_iam_policy" "key_ring" {
  key_ring_id = google_kms_key_ring.key_ring.id
  policy_data = data.google_iam_policy.kms_admin.policy_data
}

data "google_iam_policy" "kms_admin" {
  binding {
    role    = "roles/cloudkms.admin"
    members = flatten([])
  }
}

resource "google_project_iam_member" "kms_service_account_role" {
  count = var.service_account_email != "" ? 1 : 0
  project = module.test_project.project_id
  role    = "roles/cloudkms.admin"
  member  = "serviceAccount:${var.service_account_email}"
}

resource "time_sleep" "kms_service_account_role" {
  create_duration = "90s"
  depends_on = [
    google_project_iam_member.kms_service_account_role
  ]
}


resource "google_kms_crypto_key" "key" {
  for_each        = { for key, value in local.kms_keys : key => key }
  name            = each.key
  key_ring        = google_kms_key_ring.key_ring.self_link
  rotation_period = var.key_rotation_period

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.kms_labels

  depends_on = [
    google_kms_key_ring_iam_policy.key_ring
  ]
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_kms_key_ring" "key_ring" {
  name     = "hardened-gke-test-${random_string.suffix.result}"
  project  = module.test_project.project_id
  location = var.region

  depends_on = [
    time_sleep.kms_service_account_role
  ]
}

