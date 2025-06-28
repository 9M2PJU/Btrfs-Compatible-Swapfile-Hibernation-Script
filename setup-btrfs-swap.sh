#!/usr/bin/env bash

# ╔═════════════════════════════════════════════════════════════════════════════╗
# ║  🧊 Btrfs-Compatible Swapfile + Hibernation Setup Script                    ║
# ║                                                                             ║
# ║  📦 For: CachyOS / Arch-based systems with Btrfs root + GRUB (UEFI)         ║
# ║  📁 https://github.com/9M2PJU/Btrfs-Compatible-Swapfile-Hibernation-Script  ║
# ╚═════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# 🎨 Terminal colors
GREEN="\e[92m"
RED="\e[91m"
YELLOW="\e[93m"
BLUE="\e[94m"
RESET="\e[0m"

# 🔧 Config
SWAPSIZE="16G"
SWAPFILE="/swap/swapfile"
SWAPDIR="/swap"
GRUB_CFG="/boot/efi/EFI/cachyos/grub.cfg"  # Adjust if needed

# 🔊 Output helpers
log()      { echo -e "${BLUE}[INFO]${RESET} $*"; }
success()  { echo -e "${GREEN}[✔]${RESET} $*"; }
error()    { echo -e "${RED}[✘]${RESET} $*" >&2; exit 1; }
warn()     { echo -e "${YELLOW}[⚠️ WARNING]${RESET} $*"; }

intro() {
  echo -e "${YELLOW}"
  echo "╔════════════════════════════════════════════════════════════════════════════╗"
  echo "║  🧊 Btrfs-Compatible Swapfile + Hibernation Setup                          ║"
  echo "║                                                                            ║"
  echo "║  ⚠️ This script will MODIFY system files:                                  ║"
  echo "║     - /etc/fstab                                                           ║"
  echo "║     - /etc/default/grub                                                    ║"
  echo "║     - Regenerates GRUB config at: $GRUB_CFG                                ║"
  echo "║                                                                            ║"
  echo "║  💬 GitHub: github.com/9M2PJU/Btrfs-Compatible-Swapfile-Hibernation-Script ║"
  echo "║                                                                            ║"
  echo "║  🚨 DISCLAIMER:                                                            ║"
  echo "║     This script is provided AS-IS with NO WARRANTY.                       ║"
  echo "║     You are solely responsible for your system. Review before applying.   ║"
  echo "╚════════════════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

confirm_continue() {
  read -rp "$(echo -e "${YELLOW}⚠️  Proceed with setup? (y/N): ${RESET}")" confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo -e "${RED}Aborted by user.${RESET}"; exit 1; }
}

check_prerequisites() {
  [[ $(id -u) -eq 0 ]] || error "You must run this script as root."
  [[ -f /etc/fstab ]] || error "/etc/fstab is missing."
  [[ "$(stat -f -c %T /)" == "btrfs" ]] || error "Root filesystem is not Btrfs."
  [[ -f /etc/default/grub ]] || error "/etc/default/grub not found."
  [[ -d "$(dirname "$GRUB_CFG")" ]] || error "GRUB output path does not exist: $GRUB_CFG"
}

create_swapfile() {
  log "Creating Btrfs-compatible swapfile..."
  mkdir -p "$SWAPDIR"
  chmod 700 "$SWAPDIR"
  chattr +C "$SWAPDIR" || true

  truncate -s 0 "$SWAPFILE"
  chattr +C "$SWAPFILE" || true
  fallocate -l "$SWAPSIZE" "$SWAPFILE"
  chmod 600 "$SWAPFILE"
  mkswap "$SWAPFILE"
  swapon "$SWAPFILE"
  success "Swapfile created, formatted, and activated."
}

update_fstab() {
  log "Backing up and updating /etc/fstab..."
  cp /etc/fstab /etc/fstab.bak
  grep -qF "$SWAPFILE" /etc/fstab || echo "$SWAPFILE none swap defaults 0 0" >> /etc/fstab
  success "/etc/fstab updated. Backup: /etc/fstab.bak"
}

get_resume_offset() {
  log "Calculating resume offset..."
  local offset
  offset=$(filefrag -v "$SWAPFILE" | awk '/^[ ]*[0-9]+:/ { print $4; exit }' | sed 's/\.\.//')
  [[ -n "$offset" ]] || error "Failed to detect resume offset from filefrag."
  echo "$offset"
}

update_grub() {
  log "Setting resume parameters in GRUB..."
  cp /etc/default/grub /etc/default/grub.bak

  local uuid offset
  uuid=$(findmnt -no UUID /)
  offset=$(get_resume_offset)

  sed -i "s|^\(GRUB_CMDLINE_LINUX_DEFAULT=.*\)\"|\1 resume=UUID=$uuid resume_offset=$offset\"|" /etc/default/grub

  grub-mkconfig -o "$GRUB_CFG"
  success "GRUB updated. Backup: /etc/default/grub.bak"
}

final_message() {
  echo -e "${GREEN}\n🎉 Done! Btrfs swap + hibernation should now be ready.${RESET}"
  echo -e "${YELLOW}⚠️  Please reboot and test hibernation with:${RESET} systemctl hibernate"
  echo -e "💾 If something breaks, restore backups:"
  echo -e "   - /etc/fstab.bak → /etc/fstab"
  echo -e "   - /etc/default/grub.bak → /etc/default/grub"
  echo -e "\n💬 Contribute or report issues at:"
  echo -e "   ${BLUE}https://github.com/9M2PJU/Btrfs-Compatible-Swapfile-Hibernation-Script${RESET}\n"
}

main() {
  intro
  confirm_continue
  check_prerequisites
  create_swapfile
  update_fstab
  update_grub
  final_message
}

main "$@"
