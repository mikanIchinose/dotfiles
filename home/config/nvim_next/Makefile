#.PHONY: *
MAKEFLAGS += --always-make

update:
	@deno run --allow-read --allow-write --allow-net --reload https://deno.land/x/udd/main.ts rc/plugins/*.ts
