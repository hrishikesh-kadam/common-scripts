# Saved Commands

## Search

### Search only in git tracked files

```console
git ls-files --full-name --recurse-submodules \
  | xargs -I {} grep --color=auto --with-filename "to be sourced" {}
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
