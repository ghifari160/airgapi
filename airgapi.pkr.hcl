# packer {
#   required_plugins {
#     arm-image = {
#       version = "0.2.7"
#       source  = "github.com/solo-io/arm-image"
#     }
#   }
# }

locals {
  golang_archive_name = "go-linux-arm64.tar.gz"
  golang_archive_path = "/tmp/${local.golang_archive_name}"
  golang_checksum     = "${var.golang_checksum_hash}  ${local.golang_archive_path}"
  iso_url             = "https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-${var.raspbian_date}/${var.raspbian_ver}-raspios-${var.raspbian_deb_ver}-arm64-lite.img.xz"
}

source "arm-image" "raspbian" {
  image_type        = "raspberrypi"
  iso_url           = "${local.iso_url}"
  iso_checksum      = "${var.raspbian_hash}"
  output_filename   = "/build/output-raspbian/airgapi.img"
  target_image_size = 3221225472
}

build {
  name    = "airgapi"
  sources = ["source.arm-image.raspbian"]

  provisioner "shell" {
    inline = [
      "echo Provisioning user is $(whoami)"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Slimming down OS"
  }

  provisioner "shell" {
    inline = [
      "echo Uninstalling unnecessary packages",
      "sudo apt-get remove --purge -yqq v4l-utils",
      "sudo apt-get remove --purge -yqq rpi-update",
      "sudo apt-get remove --purge -yqq rpicam-apps-lite",
      "sudo apt-get remove --purge -yqq mkvtoolnix"
    ]
  }

  provisioner "file" {
    source      = "boot/config.txt"
    destination = "/boot/config.txt"
  }

  provisioner "file" {
    source      = "default"
    destination = "/etc"
  }

  provisioner "shell" {
    inline = [
      "echo Disable first user rename",
      "sudo cancel-rename pi",
      "sudo apt-get remove --purge -yqq userconf-pi"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "OS slimmed down"
  }

  provisioner "shell" {
    inline = [
      "echo Set timezone",
      "sudo echo ${var.timezone} > /etc/timezone",
      "sudo rm /etc/localtime",
      "sudo dpkg-reconfigure -f noninteractive tzdata"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Installing firstboot service"
  }

  provisioner "file" {
    source      = "firstboot/firstboot.service"
    destination = "/lib/systemd/system/firstboot.service"
  }

  provisioner "file" {
    source      = "firstboot/firstboot.sh"
    destination = "/etc/firstboot.sh"
  }

  provisioner "file" {
    source      = "firstboot/firstboot.d"
    destination = "/etc/"
  }

  provisioner "shell" {
    inline = [
      "echo Adjusting firstboot permissions",
      "sudo chmod a+r /lib/systemd/system/firstboot.service",
      "sudo chmod a+rx /etc/firstboot.sh",
      "echo Enabling firstboot service",
      "sudo ln -s /lib/systemd/system/firstboot.service /etc/systemd/system/multi-user.target.wants/firstboot.service"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Firstboot service installed"
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Upgrading packages"
  }

  provisioner "shell" {
    inline = [
      "echo Upgrading packages",
      "sudo apt-get update",
      "sudo apt-get upgrade --autoremove -yqq"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Packages upgraded"
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Installing packages"
  }

  provisioner "shell" {
    inline = [
      "echo Installing GPG",
      "sudo apt-get update",
      "sudo apt-get install --no-install-recommends -yqq gnupg2 gnupg-agent pinentry-tty"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing Smart Card tools",
      "sudo apt-get update",
      "sudo apt-get install --no-install-recommends -yqq scdaemon pcscd pcsc-tools"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing Paperkey",
      "sudo apt-get update",
      "sudo apt-get install --no-install-recommends -yqq paperkey"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing YubiKey tools",
      "sudo apt-get update",
      "sudo apt-get install --no-install-recommends -yqq yubikey-personalization yubikey-manager"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing Git",
      "sudo apt-get update",
      "sudo apt-get install --no-install-recommends -yqq git"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing Go",
      "curl -fsSL \"https://go.dev/dl/go${var.golang_ver}.linux-arm64.tar.gz\" -o ${local.golang_archive_path}",
      "echo \"${local.golang_checksum}\" | shasum -c",
      "sudo rm -rf /usr/local/go",
      "sudo tar -C /usr/local -xzvf ${local.golang_archive_path}",
    ]
  }

  provisioner "shell" {
    script = "golang/provision-profile.sh"
  }

  provisioner "shell" {
    inline = [
      "echo Installing MedHash Tools",
      "curl -fsSL \"https://projects.gassets.space/medhash-tools/${var.medhash_ver}/medhash-linux_arm64.tar.gz\" -o /tmp/medhash-linux.tar.gz",
      "mkdir -p /usr/local/medhash-tools",
      "tar -xvzf /tmp/medhash-linux.tar.gz -C /usr/local/medhash-tools",
      "cd /usr/bin",
      "ln -s ../local/medhash-tools/bin/medhash medhash"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Packages installed"
  }

  provisioner "file" {
    source      = "rc.local"
    destination = "/etc/rc.local"
  }

  provisioner "shell" {
    inline = [
      "chmod a+rx /etc/rc.local"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Disabling networking"
  }

  provisioner "shell" {
    inline = [
      "echo Uninstall SSH",
      "sudo systemctl stop ssh",
      "sudo apt-get remove --purge -yqq openssh-server openssh-client ssh-import-id"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Uninstalling networking packages",
      "sudo apt-get remove --purge -yqq avahi-daemon",
      "sudo apt-get remove --purge -yqq curl",
      "sudo apt-get remove --purge -yqq pi-bluetooth",
      "sudo apt-get remove --purge -yqq wpasupplicant wireless-tools firmware-atheros firmware-brcm80211 firmware-libertas firmware-misc-nonfree firmware-realtek",
      "sudo apt-get remove --purge -yqq raspberrypi-net-mods",
      "sudo apt-get remove --purge -yqq network-manager"
    ]
  }

  provisioner "file" {
    source      = "boot/raspi-blacklist.conf"
    destination = "/etc/modprobe.d/raspi-blacklist.conf"
  }

  provisioner "shell" {
    inline = [
      "echo Update kernel",
      # "sudo depmod -ae",
      "sudo update-initramfs -u"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Networking disabled"
  }

  provisioner "file" {
    content     = "#!/bin/bash\nC_HOSTNAME=$(cat /etc/hostname)\necho Current hostname: $C_HOSTNAME\necho Setting hostname to ${var.hostname}\nsudo sed -i \"s/$C_HOSTNAME/${var.hostname}/g\" /etc/hostname\nsudo sed -i \"s/$C_HOSTNAME/${var.hostname}/g\" /etc/hosts\nsudo hostname ${var.hostname}"
    destination = "/etc/firstboot.d/00-hostname.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod a+rx /etc/firstboot.d/00-hostname.sh"
    ]
  }

  provisioner "file" {
    source      = "motd/motd"
    destination = "/etc/motd"
  }

  provisioner "shell" {
    inline = [
      "chmod a+r /etc/motd"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Creating user",
      "adduser --disabled-password --gecos \"\" --shell /bin/bash ${var.username}",
      "usermod -g sudo ${var.username}",
      "passwd -de ${var.username}",
      "for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c netdev; do adduser ${var.username} $GRP; done",
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Provisioning root OverlayFS"
  }

  provisioner "shell" {
    inline = [
      "echo Provisioning root OverlayFS",
      "sudo mkdir -p /usr/lib/airgapi"
    ]
  }

  provisioner "file" {
    source      = "overlayfs/overlay"
    destination = "/etc/initramfs-tools/scripts/overlay"
  }

  provisioner "file" {
    source      = "overlayfs/overlayfs.sh"
    destination = "/usr/lib/airgapi/overlayfs.sh"
  }

  provisioner "file" {
    source      = "overlayfs/overlayfs.service"
    destination = "/lib/systemd/system/overlayfs.service"
  }

  provisioner "shell" {
    inline = [
      "ls -l /etc/initramfs-tools/scripts/overlay",
      "sudo chmod a+rx /etc/initramfs-tools/scripts/overlay",
      "ls -l /etc/initramfs-tools/scripts/overlay",
      "sudo chmod a+rx /usr/lib/airgapi/overlayfs.sh",
      "sudo chmod a+r /lib/systemd/system/overlayfs.service",
      "sudo ln -s /lib/systemd/system/overlayfs.service /etc/systemd/system/multi-user.target.wants/overlayfs.service"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "Root OverlayFS provisioned"
  }
}
