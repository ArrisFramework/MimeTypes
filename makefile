#!/usr/bin/make

help:
	@perl -e '$(HELP_ACTION)' $(MAKEFILE_LIST)

update:   ##@update Download mime types from Apache SVN
	@wget --no-check-certificate https://svn.apache.org/repos/asf/httpd/httpd/branches/2.4.x/docs/conf/mime.types -O ./tools/mime.types

build:    ##@build Generate new mimetypes.json and src\Mimetypes.php
	@php ./tools/generate.php

test:		##@test PHPUnit tests
	@php ./vendor/bin/phpunit --bootstrap vendor/autoload.php --testdox tests

# ------------------------------------------------
# Add the following 'help' target to your makefile, add help text after each target name starting with '\#\#'
# A category can be added with @category
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
HELP_ACTION = \
	%help; while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-_]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; for (sort keys %help) { print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { $$sep = " " x (32 - length $$_->[0]); print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; }; \
	print "\n"; }

# -eof-