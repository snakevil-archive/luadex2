DEST := var/build
LUA := $(patsubst %.moon, \
	$(DEST)/%.lua, \
	nginx.moon $(foreach dir, \
		lib lib/model lib/view, \
		$(wildcard $(dir)/*.moon) \
	) \
)

.SECONDEXPANSION:

.PHONY: all clean

all: $(LUA) var/build/sbin/analyse

var/build/sbin/analyse: sbin/analyse
	moonc -o $@ $^ > /dev/null 2>&1
	sed -e '1i #!/usr/bin/env luajit' -i'' $@
	chmod +x $@

$(LUA): $$(patsubst $(DEST)/%.lua, %.moon, $$@)
	mkdir -p $(dir $@)
	moonc -p $^ | luajit -b - - > $@

clean:
	$(RM) -r $(DEST)/*
