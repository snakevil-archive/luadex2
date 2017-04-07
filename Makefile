DOMAIN := szen.in
PREFIX := v
DESTDIR := var/build

.PHONY: all lua nginx css clean

all: lua nginx css

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
	mkdir -p $(@D)
	moonc -p $^ | luajit -b - - > $@

$(BIN): $(DESTDIR)/%: %
	moonc -o $@ $^ > /dev/null 2>&1
	sed -e '1i #!/usr/bin/env luajit' -i'' $@
	chmod +x $@

nginx: var/build/etc/nginx/sites-available/$(DOMAIN).d/luadex.sub

var/build/etc/nginx/sites-available/$(DOMAIN).d/luadex.sub: etc/nginx/sites-available/domain.d/luadex.sub
	mkdir -p $(@D)
	sed -e 's#%PREFIX%#$(PREFIX)#;s#%DOMAIN%#$(DOMAIN)#' $< > $@

css: var/build/share/static/luadex.css

var/build/share/static/luadex.css: share/scss/luadex.scss $(wildcard share/scss/_*.scss)
	node_modules/.bin/node-sass -o $(@D) --output-style compressed --linefeed lf --source-map $@.map $<

clean:
	$(RM) -r $(DESTDIR)/*
