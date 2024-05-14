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
.PHONY: install-requirements
install-requirements:
	sudo apt-get update && sudo apt-get install -y libgl1-mesa-dev
	pip install -r ${PROJECT_DIR}/requirements.txt

.PHONY: install-mmcv
install-mmcv:
	pip install -U openmim && mim install mmengine && mim install mmcv==2.1.0

.PHONY: install-mmlab
install-mmlab:
	cd ${HOME}/mmpretrain && mim install -v -e .
# cd ${HOME}/mmsegmentation && pip install -v -e .
# cd ${HOME}/mmdetection && pip install -v -e .

.PHONY: install
install: install-requirements install-mmcv install-mmlab
	@echo "*** Installation completed."


# train-------------------------------------------------------------------
.PHONY: train
train:
	cd ${HOME}/${LIB}/tools && CUBLAS_WORKSPACE_CONFIG=:4096:8 python train.py ${CONFIG}


# test--------------------------------------------------------------------
.PHONY: pytest
pytest:
	pytest -sv ./tests

.PHONY: cov
cov:
	pytest -sv --cov=src --cov-report=xml --cov-report=term ./tests
