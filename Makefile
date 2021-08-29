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

.PHONY: build
build:
	sudo bash ./build
