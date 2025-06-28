

## 📄 `README.md`

# 🧊 Btrfs Swapfile + Hibernation Setup Script for Arch-based Systems

![bash](https://img.shields.io/badge/script-bash-blue?style=flat-square)
![arch](https://img.shields.io/badge/distro-Arch%20Linux-blue?style=flat-square)
![btrfs](https://img.shields.io/badge/filesystem-btrfs-lightgrey?style=flat-square)
![license](https://img.shields.io/badge/license-MIT-green?style=flat-square)

> Fully automated, Btrfs-friendly swapfile creation with hibernation support — built for [CachyOS](https://cachyos.org) and other Arch-based Linux distros.


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
````

### 2. Run (as root)

```bash
sudo ./setup-btrfs-swap.sh
```

---

## 🧷 Pre-Flight Checklist

Make sure your system matches:

| Requirement     | Must Be                                           |
| --------------- | ------------------------------------------------- |
| Root Filesystem | Btrfs                                             |
| Bootloader      | GRUB (UEFI)                                       |
| Kernel Hook     | `resume` present in initramfs (mkinitcpio/dracut) |
| System          | Arch-based (CachyOS, Arch, EndeavourOS, etc.)     |
| Init System     | systemd                                           |

> ✅ Recommended to **back up `/etc/fstab` and `/etc/default/grub`** before proceeding.

---

## 🧪 Testing

After reboot:

```bash
systemctl hibernate
```

If it works, your system should fully power off and resume the session after powering back on.

---

## 🛠 Troubleshooting

* Did not resume? Check:

  * `resume` hook is present in `/etc/mkinitcpio.conf` or `/etc/dracut.conf`
  * You rebuilt initramfs after adding `resume` (`mkinitcpio -P` or `dracut -f`)
  * `filefrag` gave correct offset
  * Secure Boot isn't blocking resume

---

## 📚 More Info

Read the full blog post:
👉 [Setting up a Btrfs-Compatible Swap File with Hibernation on CachyOS](https://hamradio.my/2025/06/setting-up-a-btrfs-compatible-swap-file-with-hibernation-on-cachyos-or-any-arch-based-system/)

---

## 🤝 Contribute

* 💬 Found a bug? Open an issue.
* 🔧 Want to add support for systemd-boot or non-GRUB setups? PRs welcome!
* 🧪 Tested on a weird setup? Add to the compatibility list!

---

## 📄 License

MIT © [9M2PJU / hamradio.my](https://hamradio.my)

---


---

Let me know your GitHub username or repo name if you'd like this turned into a working `README.md` in a ready-to-push repo folder.
```
