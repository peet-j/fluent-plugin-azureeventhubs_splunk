# Fluent::Plugin::AzureeventhubsSplunk

Azure Event Hubs buffered output plugin for Fluentd in Splunk format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-azureeventhubs_splunk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-azureeventhubs_splunk

## Configuration

```
<match pattern>
  type azureeventhubs_splunk

  connection_string <Paste SAS connection string from Azure Management Potal>
  hub_name          <Name of Event Hubs>
  include_tag       (true|false) # true: Include tag into record [Optional: default => false]
  include_time      (true|false) # true: Include time into record [Optional: default => false]
  tag_time_name     record_time  # record tag for time when include_time sets true. [Optional: default => 'time']
  type              (https|amqps) # Connection type. [Optional: default => https]. Note that amqps is not implementated.
  expiry_interval   <Integer number> # Signature expiration time interval in seconds. [Optional: default => 3600 (60min)]
  proxy_addr       <Host or IP> # Address of the proxy [Optional]
  proxy_port	   <Integer>   # Proxy port. [Optional: default => 3128]
  read_timeout     <Integer>   # HTTP Read timeout in seconds[Optional: default => 60]
  open_timeout     <Integer>   # HTTP Open timeout in seconds[Optional: default => 60]
  message_properties <Json Object> # A json object of key/value pairs to add Properties to the events being sent to EventHubs [Optional: default => nil]
</match>
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fluent-plugin-azureeventhubs_splunk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
