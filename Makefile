#!/usr/bin/make
default:

.PHONY: default install

SHELL := $(shell which bash)
export BASH_ENV=tools/sh/env.sh

install:
	@test -e ~/.local/etc || mkdir -vp ~/.local/etc
	@test -e ~/.local/etc/profile.sh || touch ~/.local/etc/profile.sh
	@test -e /cygdrive/c/munin || ln -s $(PWD) /cygdrive/c/munin
