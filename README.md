# docker-ml-template
![python versions](https://img.shields.io/badge/python-3.8%20%7C%203.10-blue)
[![pytest](https://github.com/ykawa2/docker-ml-template/actions/workflows/pytest.yml/badge.svg)](https://github.com/ykawa2/docker-ml-template/actions/workflows/pytest.yml)

＊上記のpytestバッジのパスはプロジェクト毎に変更する必要があります <br>
＊以下のコマンドでプロジェクト名をまとめて置換できます
> find . -type f -exec sed -i 's/docker-ml-template/<your_project>/g' {} +


<br>

## ディレクトリ構成
> configs

設定ファイルを置く場所。不要なら削除してよい。

> notebooks

notebook形式のファイルを置く。

> scripts

実行用のスクリプト(.py/.sh等)を置く。<br>
＊ここにimportするファイルを置かないこと。

> src

importして使用するコードを記述する。<br>
＊ここに実行用のスクリプトを置かないこと。

> data (git管理対象外)

プロジェクトで使用するデータ等を置く。不要なら削除してよい。<br>
＊Datasetsディレクトリをローカルからマウントすることを推奨

> models (git管理対象外)

プロジェクトで使用するモデル等を置く。不要なら削除してよい。<br>
＊Modelsディレクトリをローカルからマウントすることを推奨

> outputs (git管理対象外)

プロジェクトで生成されたモデルやログ、画像等を置く。不要なら削除してよい。<br>
＊Outputsディレクトリをローカルからマウントすることを推奨

> tests

pytest記述用のディレクトリ

> .github/workflows

GitHub Actionsで実行するCI設定ファイルを置く<br>
毎回テストが実行されるためtestの作成予定がないプロジェクトであれば削除

> .vscode

VSCode設定用ファイルを置く

<br>

## マウントについて
- 個人的/小規模なプロジェクトの場合data, models, outputs内にファイルを置いてもよい
- 基本的にはプロジェクトでは管理上マウントするのが望ましい
- この場合、マウントしていることを明示的に示すためにDatasets, Models, Outputsのように先頭を大文字で記述する
