# AirGaPi

Raspberry Pi OS image designed for airgapped systems.

## Todo

- [x] Add builder Docker image.
- [x] Refactor build system to Packer-based build.
- [x] Port OverlayFS for root fs in modern Raspbian.

## Usage

In the past, AirGaPi's build system consists of applying a patch file to a pi-gen Git submodule.
We now use Hashicorp Packer.

Build the builder container image.

``` shell
docker build -t packer-builder-arm builder
```

Run the build.

``` shell
./build.sh
```

Flash the image to a media of your choice.

See [`variables.pkr.hcl`](variables.pkr.hcl) for configuration options.
