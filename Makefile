PYTHON ?= python3

.PHONY: lint-yaml test

lint-yaml:
	$(PYTHON) tests/validate_yaml.py

test: lint-yaml
