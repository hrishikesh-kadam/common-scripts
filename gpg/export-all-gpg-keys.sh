#!/usr/bin/env bash

set -e -o pipefail

source "$COMMON_SCRIPTS_ROOT/logs/logs-env.sh"

before_export="$(gpg --list-secret-keys --keyid-format long --with-sig-check "$GPG_PRIMARY_KEY")"
echo -e "Before export -\n$before_export\n"

print_in_yellow "Note: Check if the above listed key is fully constructed"
echo ""

read -srp "Enter passphrase: " GPG_PASSPHRASE
echo -e "\n"

# gpg --gen-revoke "$GPG_PRIMARY_KEY" > "$GPG_PRIMARY_KEY_FINGERPRINT".rev

echo "$GPG_PASSPHRASE" | gpg --batch --pinentry-mode loopback --passphrase-fd 0 \
  --export-secret-subkeys "$GPG_SIGN_KEY" "$GPG_ENCRYPT_KEY" "$GPG_AUTHENTICATE_KEY" \
  > hrishikesh-kadam-private-subkeys-all.gpg

gpg --batch --yes --delete-secret-and-public-keys "$GPG_AUTHENTICATE_KEY_FINGERPRINT"!

echo "$GPG_PASSPHRASE" | gpg --batch --pinentry-mode loopback --passphrase-fd 0 \
  --export-secret-subkeys "$GPG_SIGN_KEY" "$GPG_ENCRYPT_KEY" \
  > hrishikesh-kadam-private-subkeys-sign-encrypt.gpg

echo "$GPG_PASSPHRASE" | gpg --batch --pinentry-mode loopback --passphrase-fd 0 \
  --export-secret-keys "$GPG_PRIMARY_KEY" > hrishikesh-kadam-private.gpg

echo "$GPG_PASSPHRASE" | gpg --batch --pinentry-mode loopback --passphrase-fd 0 \
  --export-secret-keys --armor "$GPG_PRIMARY_KEY" > hrishikesh-kadam-private-asc.gpg

gpg --export "$GPG_PRIMARY_KEY" > hrishikesh-kadam-public.gpg

gpg --export --armor "$GPG_PRIMARY_KEY" > hrishikesh-kadam-public-asc.gpg

echo "$GPG_PASSPHRASE" | gpg --batch --pinentry-mode loopback --passphrase-fd 0 \
  --import hrishikesh-kadam-private-subkeys-all.gpg &> /dev/null

after_export=$(gpg --list-secret-keys --keyid-format long --with-sig-check "$GPG_PRIMARY_KEY")
echo -e "After export - \n$after_export\n"

if [[ "$before_export" == "$after_export"  ]]; then
  print_in_green "Key matches to the state before it was exported"
else
  print_in_red "Key doesn't matches to the state before it was exported"
fi
