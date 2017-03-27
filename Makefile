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

all: $(LUA)

$(LUA): $$(patsubst $(DEST)/%.lua, %.moon, $$@)
	moonc -o $@ $^

clean:
	$(RM) -r $(DEST)/*
