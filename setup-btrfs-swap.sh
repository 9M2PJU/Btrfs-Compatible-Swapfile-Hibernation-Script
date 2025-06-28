# 🧊 Btrfs Swapfile + Hibernation Setup Script for Arch-based Systems

![bash](https://img.shields.io/badge/script-bash-blue?style=flat-square)
![arch](https://img.shields.io/badge/distro-Arch%20Linux-blue?style=flat-square)
![btrfs](https://img.shields.io/badge/filesystem-btrfs-lightgrey?style=flat-square)
![license](https://img.shields.io/badge/license-MIT-green?style=flat-square)

> Fully automated, Btrfs-friendly swapfile creation with hibernation support — built for [CachyOS](https://cachyos.org) and other Arch-based Linux distros.

---

## ⚡ What It Does

- 📁 Creates a **CoW-safe Btrfs swapfile**
- ⚙️ Appends proper config to `/etc/fstab`
- 🧠 Calculates `resume_offset` using `filefrag`
- 🧬 Injects kernel `resume=` and `resume_offset=` parameters into GRUB
- 🔁 Regenerates GRUB config for UEFI boot
- 💬 Friendly CLI output with confirmations and backups

---

## 🚀 Quick Start

### 1. Download

```bash
curl -LO https://raw.githubusercontent.com/yourusername/btrfs-hibernate-arch/main/setup-btrfs-swap.sh
chmod +x setup-btrfs-swap.sh
