define COMMENT

make update

make add
x1 x1

make list

endef

.PHONY: update
update:
	git pull --recurse-submodules
	git submodule update --remote --recursive


.PHONY: list
list:
	ls pkg

.PHONY: add
add:
	read ff && for f in $$ff; do git submodule add https://aur.archlinux.org/$$f pkg/$$f; done

.DEFAULT_GOAL := all
.PHONY: all
all:
	sudo -E bash ./build

.PHONY: build
build:
	for f in $$(ls pkg); do sudo -E bash ./build pkg/$$f; done
