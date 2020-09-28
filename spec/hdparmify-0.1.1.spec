Name: hdparmify
Version: 0.1.1
Release: 2%{?dist}
Summary: Hard drive management with hdparm

License: MIT
URL: https://github.com/jcrd/hdparmify
Source0: https://github.com/jcrd/hdparmify/archive/v0.1.1.tar.gz

BuildArch: noarch

BuildRequires: perl

# Required for testing.
BuildRequires: iniq >= 0.3.0

Requires: bash
Requires: coreutils
Requires: iniq >= 0.3.0
Requires: hdparm

%global debug_package %{nil}

%description
hdparmify applies hdparm options to hard drives via a udev rule. It also provides systemd services: hdparmify-reapply to reapply options after waking up and hdparmify-restore to restore devices to their default state before shutdown.

%prep
%setup

%build
%make_build PREFIX=/usr

%install
%make_install PREFIX=/usr

%check
make test

%files
%license LICENSE
%doc README.md
%config(noreplace) /etc/hdparmify.conf
/usr/bin/%{name}
/usr/lib/udev/rules.d/99-hdparmify.rules
/usr/lib/systemd/system/hdparmify@.service
/usr/lib/systemd/system/hdparmify-reapply.service
/usr/lib/systemd/system/hdparmify-restore.service
/usr/share/man/man1/%{name}.1.gz

%changelog
* Mon Sep 28 2020 James Reed <jcrd@tuta.io> - 0.1.1-2
- Mark /etc/hdparmify.conf as configuration

* Mon Sep 28 2020 James Reed <jcrd@tuta.io> - 0.1.1-1
- Release v0.1.1

* Mon Sep 28 2020 James Reed <jcrd@tuta.io> - 0.1.0-1
- Initial package
