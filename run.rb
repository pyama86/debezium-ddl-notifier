require 'google/cloud/pubsub'
require 'json'
require 'slack-ruby-client'
require 'sentry-ruby'
if ENV['SENTRY_DSN']
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
  end
end

Thread.new do
  server = TCPServer.new('0.0.0.0', 1234)
  loop do
    sock = server.accept
    line = sock.gets
    sock.write("HTTP/1.0 200 OK\n\nok")
    sock.close
  end
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end
client = Slack::Web::Client.new
pubsub = Google::Cloud::PubSub.new(
  project_id: ENV['PROJECT_ID']
)

sub = pubsub.subscription ENV['SUBSCRIPTION_NAME']

subscriber = sub.listen do |received_message|
  j = JSON.parse(received_message.message.data)

  if j['payload']['ddl']
    client.chat_postMessage(
      channel: '#' + ENV['SLACK_CHANNEL'],
      blocks: [
        {
          "type": 'header',
          "text": {
            "type": 'plain_text',
            text: 'Debezium Event',
            "emoji": true
          }
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "Pub/Sub Subscription:#{ENV['SUBSCRIPTION_NAME']} recieved ddl: `#{j['payload']['ddl'].gsub('`', "'")}`"
          }
        }
      ]
    )
    received_message.acknowledge!
  end
rescue StandardError => e
  Sentry.capture_exception(e)
end

subscriber.on_error do |exception|
  puts "Exception: #{exception.class} #{exception.message}"
end

at_exit do
  subscriber.stop!(10)
end

subscriber.start
sleep
