KDIR ?= /lib/modules/$(shell uname -r)/build
export DTC ?= /usr/bin/dtc

all:
	$(MAKE) -C $(KDIR) M=$$PWD modules

clean:
	$(MAKE) -C $(KDIR) M=$$PWD $@

install:
	install -d $(DESTDIR)/usr/bin
	install -m755 x735.sh $(DESTDIR)/usr/bin/

	install -d $(DESTDIR)/lib/systemd/system
	install -m 644 x735monitor.service  $(DESTDIR)/lib/systemd/system/
	install -m 644 x735poweroff.service $(DESTDIR)/lib/systemd/system/
	install -m 644 x735reboot.service   $(DESTDIR)/lib/systemd/system/

	install -d $(DESTDIR)/usr/share/x735
	install -m 644 x735-cooling-fan.dtbo $(DESTDIR)/usr/share/x735/

#	$(MAKE) -C $(KDIR) M=$$PWD modules_install

