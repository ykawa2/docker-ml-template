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
# MAX_JOBSを指定しないとnvcc error : 'cudafe++' died due to signal 9 (Kill signal)が発生する場合あり
# export MAX_JOBS=12; pip install -U openmim && mim install mmengine && mim install mmcv==2.1.0
# wheelファイルを取っておくと便利
	pip install /home/docker/docker-ml-template/mmcv-2.1.0-cp310-cp310-linux_x86_64.whl

.PHONY: install-mmlab
install-mmlab:
	cd ${HOME} && git clone -b v1.2.0 https://github.com/open-mmlab/mmpretrain.git
	cd ${HOME} && git clone -b v3.3.0 https://github.com/open-mmlab/mmdetection.git
	cd ${HOME} && git clone -b v1.2.2 https://github.com/open-mmlab/mmsegmentation.git
	cd ${HOME} && git clone -b v1.3.1 https://github.com/open-mmlab/mmpose.git
	cd ${HOME}/mmpretrain && mim install -v -e .
	cd ${HOME}/mmsegmentation && pip install -v -e .
	cd ${HOME}/mmdetection && pip install -v -e .
	cd ${HOME}/mmpose && pip install -v -e .

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


# others-------------------------------------------------------------------
.PHONY: check_gpu
gpu:
	python -c "import torch; print('CUDA available:', torch.cuda.is_available())"