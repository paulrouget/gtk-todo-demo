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

fmt:
	cargo +nightly fmt

check-fmt:
	cargo +nightly fmt --check

readme:
	cargo doc2readme --expand-macros --out Readme.md

check-readme:
	cargo doc2readme --expand-macros --out Readme.md --check

fix: fmt readme
	cargo +nightly cranky --all-features --fix

check-udeps:
	cargo +nightly udeps --all-features

check-cranky:
	cargo +nightly cranky --all-features -- -D warnings

check: doc check-readme check-fmt check-udeps check-cranky

test:
	cargo test --all-features

setup:
	rustup install nightly
	rustup component add rustfmt --toolchain nightly
	cargo install cargo-doc2readme
	cargo install cargo-cranky
	cargo install cargo-udeps --locked

clean:
	rm -rf target
