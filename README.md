# Dotfiles

**Note:** Make sure to clone this repository recursively, as it contains submodules.

My Linux, macOS, and Windows dotfiles. (Windows and macOS configurations are in separate branches.)

## Usage

### Enable a configuration:
```sh
./setup.sh enable "CONFIG_NAME"
```
*Replace `CONFIG_NAME` with the filename of the configuration inside `./config` (not `.config`).*

### Disable a configuration:
```sh
./setup.sh disable
```
