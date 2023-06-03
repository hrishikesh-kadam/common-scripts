# Saved Commands

## Search

### Search only in git tracked files

```console
git ls-files --full-name --recurse-submodules \
  | xargs -I {} grep --color=auto --with-filename "text to search" {}
```

## Source commands header and footer

```sh
if [ -z ${-%*e*} ]; then PARENT_ERREXIT=true; else PARENT_ERREXIT=false; fi
if shopt -qo pipefail; then PARENT_PIPEFAIL=true; else PARENT_PIPEFAIL=false; fi

if [ $PARENT_ERREXIT = "true" ]; then set -e; else set +e; fi
if [ $PARENT_PIPEFAIL = "true" ]; then set -o pipefail; else set +o pipefail; fi
```

## Flash images to USB

Source - https://askubuntu.com/a/377561/934644

### Linux

```console
sudo dd \
  bs=4M \
  if=path/to/input.iso \
  of=/dev/sd<?> \
  conv=fdatasync \
  status=progress
```

### macOS

```console
sudo dd \
  if=path/to/input.img \
  of=/dev/disk<?> \
  bs=4m \
  && sync
```
