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

variable "raspbian_date" {
  type    = string
  default = "2025-10-02"
}

variable "raspbian_ver" {
  type    = string
  default = "2025-10-01"
}

variable "raspbian_deb_ver" {
  type    = string
  default = "trixie"
}

variable "raspbian_hash" {
  type    = string
  default = "sha256:79146135607ffe8acac94e5ff501de6fc49583117de5ad08c45a32c73ae2a027"
}

variable "golang_ver" {
  type    = string
  default = "1.25.4"
}

variable "golang_checksum_hash" {
  type    = string
  default = "a68e86d4b72c2c2fecf7dfed667680b6c2a071221bbdb6913cf83ce3f80d9ff0"
}

variable "medhash_ver" {
  type    = string
  default = "0.6.1"
}
