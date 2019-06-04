VERSIONCMD = git describe --dirty --tags --always 2> /dev/null
VERSION := $(shell $(VERSIONCMD) || cat VERSION)

PREFIX ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin
LIBPREFIX ?= $(PREFIX)/lib
MANPREFIX ?= $(PREFIX)/share/man

MANPAGE = hdparmify.1

all: hdparmify $(MANPAGE)

hdparmify: hdparmify.in
	sed -e "s/VERSION=/VERSION=$(VERSION)/" hdparmify.in > hdparmify
	chmod +x hdparmify

$(MANPAGE): man/$(MANPAGE).pod
	pod2man -n=hdparmify -c=hdparmify -r=$(VERSION) $< $(MANPAGE)

install:
	mkdir -p $(DESTDIR)$(BINPREFIX)
	cp -p hdparmify $(DESTDIR)$(BINPREFIX)
	mkdir -p $(DESTDIR)/etc
	cp -p hdparmify.conf $(DESTDIR)/etc
	mkdir -p $(DESTDIR)$(LIBPREFIX)/udev/rules.d
	cp -p udev/99-hdparmify.rules $(DESTDIR)$(LIBPREFIX)/udev/rules.d
	mkdir -p $(DESTDIR)$(LIBPREFIX)/systemd/system
	cp -p systemd/hdparmify@.service $(DESTDIR)$(LIBPREFIX)/systemd/system
	cp -p systemd/hdparmify-reapply.service $(DESTDIR)$(LIBPREFIX)/systemd/system
	cp -p systemd/hdparmify-restore.service $(DESTDIR)$(LIBPREFIX)/systemd/system
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	cp -p $(MANPAGE) $(DESTDIR)$(MANPREFIX)/man1

uninstall:
	rm -f $(DESTDIR)$(BINPREFIX)/hdparmify
	rm -f $(DESTDIR)/etc/hdparmify.conf
	rm -f $(DESTDIR)$(LIBPREFIX)/udev/rules.d/99-hdparmify.rules
	rm -f $(DESTDIR)$(LIBPREFIX)/systemd/system/hdparmify@.service
	rm -f $(DESTDIR)$(LIBPREFIX)/systemd/system/hdparmify-reapply.service
	rm -f $(DESTDIR)$(LIBPREFIX)/systemd/system/hdparmify-restore.service
	rm -f $(DESTDIR)$(MANPREFIX)/man1/hdparmify.1

clean:
	rm -f hdparmify $(MANPAGE)

test: hdparmify
	$(MAKE) -C test

.PHONY: all install uninstall clean test
