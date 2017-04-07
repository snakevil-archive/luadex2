DOMAIN := szen.in
PREFIX := v
DESTDIR := var/build

.PHONY: all lua nginx clean

all: lua nginx

LUA := $(patsubst %.moon, \
	$(DESTDIR)/%.lua, \
	nginx.moon $(foreach dir, \
		lib lib/model lib/view, \
		$(wildcard $(dir)/*.moon) \
	) \
)
BIN := $(patsubst %, \
	$(DESTDIR)/%, \
	$(foreach dir, \
		sbin, \
		$(wildcard $(dir)/*) \
	) \
)

lua: $(LUA) $(BIN)

$(LUA): $(DESTDIR)/%.lua: %.moon
	mkdir -p $(dir $@)
	moonc -p $^ | luajit -b - - > $@

$(BIN): $(DESTDIR)/%: %
	moonc -o $@ $^ > /dev/null 2>&1
	sed -e '1i #!/usr/bin/env luajit' -i'' $@
	chmod +x $@

nginx: var/build/etc/nginx/sites-available/$(DOMAIN).d/luadex.sub

var/build/etc/nginx/sites-available/$(DOMAIN).d/luadex.sub: etc/nginx/sites-available/domain.d/luadex.sub
	mkdir -p $(dir $@)
	sed -e 's#%PREFIX%#$(PREFIX)#;s#%DOMAIN%#$(DOMAIN)#' $< > $@

clean:
	$(RM) -r $(DESTDIR)/*
