DEST := var/build
LUA := $(patsubst %.moon, \
	$(DEST)/%.lua, \
	nginx.moon $(foreach dir, \
		lib lib/model lib/view, \
		$(wildcard $(dir)/*.moon) \
	) \
)
BIN := $(patsubst %, \
	$(DEST)/%, \
	$(foreach dir, \
		sbin, \
		$(wildcard $(dir)/*) \
	) \
)

.SECONDEXPANSION:

.PHONY: all clean

all: $(LUA) $(BIN)

$(LUA): $$(patsubst $(DEST)/%.lua, %.moon, $$@)
	mkdir -p $(dir $@)
	moonc -p $^ | luajit -b - - > $@

$(BIN): $$(patsubst $(DEST)/%, %, $$@)
	moonc -o $@ $^ > /dev/null 2>&1
	sed -e '1i #!/usr/bin/env luajit' -i'' $@
	chmod +x $@

clean:
	$(RM) -r $(DEST)/*
