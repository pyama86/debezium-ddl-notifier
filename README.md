# Debezium Event Notifier
このプロジェクトは、Google Cloud Pub/Subを介してDebeziumイベントを購読し、新しいDDLイベントが受信されたときにSlackに通知を送信するRubyスクリプトです。

## 設定
このスクリプトを実行するには、環境変数を設定する必要があります。
- SLACK_API_TOKEN: あなたのSlackワークスペースのAPIトークンです。[こちら](https://api.slack.com/apps)でSlackアプリを作成し、ボットトークンを取得してください。
- PROJECT_ID: Google CloudプロジェクトのIDです。
- SUBSCRIPTION_NAME: Google Cloud Pub/Subのサブスクリプション名です。
- SLACK_CHANNEL: 通知を送信したいSlackチャンネルです。
## 使い方
1. 必要な依存関係をインストールします:

   $ bundle install

2. 環境変数を設定して、スクリプトを起動します:

   $ SLACK_API_TOKEN=<your slack API token> PROJECT_ID=<your project id> SUBSCRIPTION_NAME=<your subscription name> SLACK_CHANNEL=<your slack channel> bundle exec ruby run.rb

3. 新しいDDLイベントがDebeziumとPub/Subを介して受信されると、指定されたSlackチャンネルに通知が送信されます。
## 注意事項
- このスクリプトはDDLイベントのみを検出し、Slackに通知します。DMLイベントに対応するには、`received_message.message.data`の中身を確認し、それに応じたSlack通知を作成する必要があります。
- 例外が発生した場合、単に標準出力に書き込まれます。必要に応じて、例外処理ロジックを追加してください。
- サービスとしてデプロイする場合は、デーモン化やプロセス管理などの機能を実装する必要があります。
## ライセンス
MIT
## 作者
- pyama86
