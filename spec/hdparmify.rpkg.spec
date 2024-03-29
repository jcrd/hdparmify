Name: {{{ git_cwd_name name="hdparmify" }}}
Version: {{{ git_cwd_version lead="$(git tag | sed -n 's/^v//p' | sort --version-sort -r | head -n1)" }}}
Release: 1%{?dist}
Summary: Hard drive management with hdparm

License: MIT
URL: https://github.com/jcrd/hdparmify
VCS: {{{ git_cwd_vcs }}}
Source0: {{{ git_cwd_pack }}}

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
{{{ git_cwd_setup_macro }}}

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
{{{ git_cwd_changelog }}}
