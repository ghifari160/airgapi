# AirGaPi

Raspberry Pi OS image designed for airgapped systems.

## How AirGaPi works

AirGaPi uses Git submodule to include [pi-gen](https://github.com/rpi-distro/pi-gen) in the repository.
The included pi-gen is then patched with [airgapi.patch.asc](airgapi.patch.asc).

## Differences with pi-gen stages

AirGaPi stages work slightly differently than [pi-gen stages](https://github.com/rpi-disto/pi-gen#stage-anatomy).

| Stage    | Difference                                                                                         |
|----------|----------------------------------------------------------------------------------------------------|
| `stage0` | No difference.                                                                                     |
| `stage1` | `raspi-config` installed with `no-install-recommends` flag. Boot partition set to readonly. Root fs set to readonly. Root fs mounted as overlay with tmpfs backing (changes stored on ram, not persisted to disk). |
| `stage2` | Networking features are removed. NOOBS export removed.                                             |
| `stage3` | UI features are removed. GPG, smartcard tools, YubiKey Manager, and exFAT utilities are installed. |
| `stage4` | Skipped. No difference.                                                                            |
| `stage5` | Skipped. No difference.                                                                            |

## Dependencies

- Docker
- GPG

Additionally, the host kernel must have `binfmt-support` enabled.
See [pi-gen Docker build](https://github.com/RPi-Distro/pi-gen#docker-build).

## Usage

Prepare the build environment (this will apply [airgapi.patch.asc](airgapi.patch.asc) to [pi-gen](pi-gen))

``` shell
./prepare-airgapi.sh
```

Update the configuration in `config`, then run `prepare-airgapi.sh` again to apply the changes.

Run the build

``` shell
./build-airgapi.sh
```
