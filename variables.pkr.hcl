variable "username" {
  type    = string
  default = "airgapi"
}

variable "hostname" {
  type    = string
  default = "airgapi"
}

variable "timezone" {
  type    = string
  default = "America/Chicago"
}

variable "raspbian_ver" {
  type    = string
  default = "2024-11-19"
}

variable "raspbian_deb_ver" {
  type    = string
  default = "bookworm"
}

variable "raspbian_hash" {
  type    = string
  default = "sha256:6ac3a10a1f144c7e9d1f8e568d75ca809288280a593eb6ca053e49b539f465a4"
}

variable "golang_ver" {
  type    = string
  default = "1.23.4"
}

variable "golang_checksum_hash" {
  type    = string
  default = "16e5017863a7f6071363782b1b8042eb12c6ca4f4cd71528b2123f0a1275b13e"
}

variable "medhash_ver" {
  type    = string
  default = "0.6.1"
}
