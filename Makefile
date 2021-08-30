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
	read ff && for f in $$ff; do git submodule add https://aur.archlinux.org/$$f pkg/$$f; git config -f .gitmodules submodule.pkg/$$f.ignore dirty; done

.PHONY: remove
remove:
	read ff && for f in $$ff; do git-remove-submodule pkg/$$f; done

# make PKG=name_inside_pkg_folder
# make
.DEFAULT_GOAL := all
.PHONY: all
all:
	sudo -E bash ./build pkg/$(PKG)

.PHONY: build
build:
	for f in $$(ls pkg); do sudo -E bash ./build pkg/$$f; done
