# lid-server

Keep the 2017 MacBook Pro running Omarchy awake with the lid closed, so it can
sit on a shelf as an SSH box.

```sh
omarchy-setup-security-sshd --gh-keys archae0pteryx   # sshd + ufw + keys, passwords off
task linux:lid-server                                 # or: linux/lid-server/lid-server install
task linux:lid-server:status                          # everything should read "ok"
```

Undo with `task linux:lid-server:remove`.

## How Omarchy handles the lid

Two separate things react when the lid closes, and only one of them suspends.
Paths are relative to `$OMARCHY_PATH` (`~/.local/share/omarchy`).

| Layer | What it does on lid close | Source |
| --- | --- | --- |
| Hyprland | `switch:on:Lid Switch` runs `omarchy-system-lid-close`, which locks the session. About 5 seconds later the lock screen turns the panel and keyboard backlight off. | `default/hypr/bindings/utilities.lua`, `bin/omarchy-system-lid-close`, `shell/plugins/lock/Service.qml` |
| systemd-logind | Suspends. Omarchy never sets `HandleLidSwitch`, so logind's default (`suspend`) applies. Its only drop-ins set `HandlePowerKey=ignore` and `InhibitDelayMaxSec=15`. | `etc/systemd/logind.conf.d/` |

Idle never suspends either. Quickshell's idle service only starts the
screensaver at 150 s and locks at 300 s.

So the fix belongs in logind, and the Hyprland half is worth keeping: locking
and blanking the panel is what keeps the closed lid from cooking the screen.

## Why not fix suspend instead

Suspend and resume on the 2016–2017 MacBook Pros are still broken upstream.
With no keyboard attached, a box that fails to resume has to be power-cycled by
hand.

- **MacBookPro14,1 (13", no Touch Bar).** Closing the lid suspends, but the
  machine never resumes, even with Omarchy's existing `d3cold_allowed=0` NVMe
  fix ([omarchy#14409](https://github.com/omacom/omarchy/pull/14409), still
  open). The proposed fix needs `mem_sleep_default=s2idle`,
  `nvme_core.default_ps_max_latency_us=0` and `intel_idle.max_cstate=1`, and it
  has only been tested for minutes, not hours.
- **Thunderbolt on 14,1.** Deep (S3) sleep loses the Alpine Ridge
  controller, and the USB-C ports with it. Apple's EFI disables the Thunderbolt
  root port when a device is attached during S3. The fix is an out-of-tree DKMS
  shim that hasn't merged yet
  ([omarchy#10593](https://github.com/omacom/omarchy/issues/10593)).
- **MacBookPro14,3 (15").** S3 fails because `amdgpu` errors out reloading the
  SMU. s2idle draws about 7–13 W, compared with about 0.25 W in S3 (comments on
  #14409).
- **The Dunedan tracker lists suspend as "partially working" on every 14,x
  model**, with resume taking up to a minute
  ([mbp-2016-linux](https://github.com/Dunedan/mbp-2016-linux)).

The setup here never sleeps, so none of these bugs can trigger.

## What `lid-server install` does

1. `/etc/systemd/logind.conf.d/90-lid-server.conf` sets `HandleLidSwitch`,
   `HandleLidSwitchExternalPower` and `HandleLidSwitchDocked` to `ignore`. The
   file sorts after Omarchy's `10-` and `20-` drop-ins.
2. `/etc/systemd/sleep.conf.d/90-lid-server.conf` sets `AllowSuspend=no` and
   disables hibernation as well. This covers suspend requests that don't come
   from the lid: the system menu, `systemctl suspend` typed over SSH, or an app
   asking. logind then reports `CanSuspend=na`.
3. It reloads logind with SIGHUP rather than restarting it, because restarting
   it can kill the Hyprland session. If the status check still shows `suspend`
   afterwards, reboot.
4. It runs `omarchy-toggle suspend-off on`, which hides "Suspend" from the
   Omarchy system menu.

`lid-server status` reports all of this, plus the model, lid and AC state, how
many times the machine has suspended this boot, sshd, and the machine's IP
addresses.

## Testing it

```sh
task linux:lid-server:status          # all ok
# close the lid, wait 5+ minutes, then from another machine:
ssh <you>@<host> 'uptime; ~/dotfiles/linux/lid-server/lid-server status'
```

`suspends this boot` should still read 0. If it doesn't,
`journalctl -b -u systemd-logind` will show who asked for it.

## Other things that can still take it offline

None of these are handled here. They are listed roughly in order of how likely
they are to bite.

### Disk encryption and reboots

If Omarchy encrypted the disk (`lsblk -f` shows `crypto_LUKS`), every reboot
stops at the LUKS passphrase prompt, before networking or sshd start. A short
power cut won't trigger this, because the battery acts as a UPS. A kernel
update that needs a reboot will. Either accept being physically present for reboots, or set up
SSH unlock in the initramfs. Omarchy on x86 uses the busybox `encrypt` hook
(`etc/mkinitcpio.conf.d/00-omarchy-hooks.conf`), which works with the classic
`netconf` + `dropbear` + `encryptssh` hooks
([remote unlocking](https://wiki.archlinux.org/title/User:Wolegis/Remote_unlocking)).
Because Omarchy writes the HOOKS baseline, the swap has to live in a later
drop-in. Remote unlock also needs wired networking, which on this machine means
a USB-C Ethernet adapter, since Wi-Fi in early boot isn't practical.

### Battery left at 100% around the clock

A lithium battery that is held full and warm ages fast. The 13" non-Touch Bar
2016–2017 model already had a known swelling defect: Apple ran a
[replacement program](https://www.engadget.com/2018/04/21/apple-will-replace-swollen-batteries-in-newer-macbook-pros/)
for it, and that program has now expired. Mainline Linux has no charge limit
for Intel Macs. Two out-of-tree options write the SMC `BCLM` key:

- [`applesmc-next-dkms`](https://github.com/c---/applesmc-next) (AUR). It adds
  `/sys/class/power_supply/BAT0/charge_control_end_threshold`, which Omarchy's
  battery status already reads. The limit stays in the SMC until an SMC reset.
- [`macbook-charge-limit`](https://github.com/jtbrough/macbook-charge-limit).
  This is a userspace tool with a systemd unit.

Neither project lists the 2017 MBP as tested. Set it to 80, then watch
`/sys/class/power_supply/BAT0/capacity` level off before trusting it. Even with
a limit, check the bottom case now and then for bulging.

### Heat

Fans and sensors work out of the box through `applesmc`, and Omarchy already
installs `thermald`. The 2016+ chassis vents near the hinge, which a closed lid
narrows but doesn't block. Apple supports running these machines with the lid
closed (clamshell mode), so light server load is fine. If it
runs hot under real load, `mbpfan` (AUR) switches the fan curve to a more
aggressive one. Check temperatures with `sensors`.

### Wi-Fi

Omarchy already turns Wi-Fi power saving off
(`etc/NetworkManager/conf.d/omarchy-wifi-powersave.conf`), disables USB
autosuspend, and fixes the `brcmfmac` WPA handshake bug on Apple Broadcom chips.
For a server, a USB-C Ethernet adapter is still more dependable. Give the
machine a DHCP reservation, or use Tailscale, so its address doesn't move.
Check the model with `cat /sys/class/dmi/id/product_name`. On a Touch Bar
model (13,2 / 13,3 / 14,2 / 14,3), see
[omarchy-macbookpro-t1](https://github.com/nohzafk/omarchy-macbookpro-t1) for
its 5 GHz Wi-Fi fix.

### Updates

`omarchy-update` is safe to run over SSH. With sleep disabled, nothing can
suspend the machine partway through, which Omarchy's own update inhibitor
doesn't fully prevent ([omarchy#10203](https://github.com/omacom/omarchy/issues/10203)).
Reboot afterwards only when you can get to the machine, or once remote unlock
is set up.
