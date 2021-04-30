.PHONY: lint
lint:
	mypy src

# Run tests
.PHONY: test 
test:
	python3 -m pytest

# Install this repo, plus dev requirements, in editable mode
.PHONY: install 
install:
	pip3 install -r requirements.txt -r requirements_dev.txt
	pip3 install -e .
