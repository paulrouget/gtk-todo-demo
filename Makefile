SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DESTDIR=/tmp/gtk-local/

build:
	PKG_CONFIG_PATH=${DESTDIR}/lib/pkgconfig/ \
	cargo build

run:
	PKG_CONFIG_PATH=${DESTDIR}/lib/pkgconfig/ \
	DYLD_LIBRARY_PATH=${DESTDIR}/lib/ \
	GSETTINGS_SCHEMA_DIR=target/schemas/ \
	cargo run

lldb:
	PKG_CONFIG_PATH=${DESTDIR}/lib/pkgconfig/ \
	DYLD_LIBRARY_PATH=${DESTDIR}/lib/ \
	GSETTINGS_SCHEMA_DIR=target/schemas/ \
	lldb ./target/debug/todo

install:
	mkdir -p target/schemas/
	cp ./src/todo.gschema.xml target/schemas/
	glib-compile-schemas target/schemas/

