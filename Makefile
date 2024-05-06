PROJECT_DIR=/home/docker/docker-ml-template

# devcontainer------------------------------------------------------------
.PHONY: set-prompt
set-prompt:
	echo '. ${PROJECT_DIR}/scripts/add_gitinfo_to_prompt.sh' >> ~/.bashrc

.PHONY: set-symlinks
set-symlinks:
	@echo "*** Creating ${HOME}/.vscode"
	mkdir -p ${HOME}/.vscode
	@echo "*** Creating symlinks for vscode settings.json"
	ln -sf ${PROJECT_DIR}/.vscode/settings.json ${HOME}/.vscode/settings.json
	@echo "*** Creating symlinks for vscode launch.json"
	ln -sf ${PROJECT_DIR}/.vscode/launch.json ${HOME}/.vscode/launch.json
	@echo "*** Creating symlinks for pyproject.toml"
	test ! -e ${HOME}/pyproject.toml && ln -s ${PROJECT_DIR}/pyproject.toml ${HOME}/pyproject.toml

.PHONY: setup
setup: set-prompt set-symlinks
	@echo "*** Setup completed."

# installation------------------------------------------------------------
.PHONY: install
install:
	pip install -r ${PROJECT_DIR}/requirements.txt


# train-------------------------------------------------------------------


# test--------------------------------------------------------------------
.PHONY: pytest
pytest:
	pytest -sv ./tests

.PHONY: cov
cov:
	pytest -sv --cov=src --cov-report=xml --cov-report=term ./tests
