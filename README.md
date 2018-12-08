# hdparmify [![Build Status](https://travis-ci.org/jcrd/hdparmify.svg?branch=master)](https://travis-ci.org/jcrd/hdparmify)

hdparmify applies **hdparm** options to hard drives via a udev rule.
It also provides **systemd** services: _hdparmify-reapply_ to reapply
options after waking up and _hdparmify-restore_ to restore devices to
their default state before shutdown.

## Usage

```
usage: hdparmify [options] [command]

options:
  -h         Show help message
  -c CONFIG  Path to config
  -d DEVICE  Device to affect
  -t         Exit successfully if device not in config
  -n         Ignore delay options

commands:
  apply      Affect devices
  reset      Reset state
  reapply    Reset state and apply
  restore    Restore devices to default state
  status     Print status
```

## Configuration

Sections in the configuration file _/etc/hdparmify.conf_ are names of devices.
The available options are shown below (with the corresponding **hdparm** flag in
parentheses). See **hdparm**(8) for details about each option.

* `power_management=`

Set Advanced Power Management (**-B**). Values are in the range 1-255.

* `acoustic_management=`

Set Automatic Acoustic Management (**-M**). Values are in the range 0-254.

* `standby_timeout=`

Put the drive into idle (low-power) mode and set the standby (spindown)
timeout (**-S**). Values are in the range 0-253,255.

* `power_mode=`

This option takes one of two values: standby (**-y**) or sleep (**-Y**).
Standby mode usually causes a device to spin down.
Sleep mode causes a device to shut down completely.

* `delay=`

This option is specific to **hdparmify**. Its value is the number of seconds to
wait before affecting a device.

## License

This project is licensed under the MIT License (see [LICENSE](LICENSE)).
