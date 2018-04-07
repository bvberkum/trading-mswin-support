#!/usr/bin/make
default:

.PHONY: default install

SHELL := $(shell which bash)
export BASH_ENV=tools/sh/env.sh

install:
	@test -e /cygdrive/c/munin || echo ln -s $(PWD) /cygdrive/c/munin
