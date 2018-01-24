module Fluent::Plugin

  class AzureEventHubsOutputSplunk < Output
    Fluent::Plugin.register_output('azureeventhubs_splunk', self)

    helpers :compat_parameters, :inject

    DEFAULT_BUFFER_TYPE = "memory"

    config_param :connection_string, :string
    config_param :hub_name, :string
    config_param :include_tag, :bool, :default => false
    config_param :include_time, :bool, :default => false
    config_param :tag_time_name, :string, :default => 'time'
    config_param :expiry_interval, :integer, :default => 3600 # 60min
    config_param :type, :string, :default => 'https' # https / amqps (Not Implemented)
    config_param :proxy_addr, :string, :default => ''
    config_param :proxy_port, :integer,:default => 3128
    config_param :open_timeout, :integer,:default => 60
    config_param :read_timeout, :integer,:default => 60
    config_param :message_properties, :hash, :default => nil
    config_param :max_events_per_send, :integer, :default => 100

    config_section :buffer do
      config_set_default :@type, DEFAULT_BUFFER_TYPE
      config_set_default :chunk_keys, ['tag']
    end

    def configure(conf)
      compat_parameters_convert(conf, :buffer, :inject)
      super
      case @type
      when 'amqps'
        raise NotImplementedError
      else
        require_relative 'azureeventhubsplunk/http'
        @sender = AzureEventHubsSplunkHttpSender.new(self, @connection_string, @hub_name, @expiry_interval, @proxy_addr, @proxy_port, @open_timeout, @read_timeout)
      end
      raise Fluent::ConfigError, "'tag' in chunk_keys is required." if not @chunk_key_tag
    end

    def format(tag, time, record)
      record = inject_values_to_record(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def formatted_to_msgpack_binary?
      true
    end

    def write(chunk)
      log.info "Have EventHub chunk to write..."
      chunk.msgpack_each { |tag, time, record|
        records ||= []
        p record.to_s
        if @include_tag
          record['tag'] = tag
        end
        if @include_time
          record[@tag_time_name] = time
        end
        records << record
      }
      log.info "Processed batch of #{records.size()}. Forwarding to EventHub..."
      process_in_batches(records)
    end

    # This will need tuning dependent on eventhub/splunk payload limits
    # Also ought to have some error handling
    def process_in_batches(records)
      records.each_slice(@max_events_per_send).each { |batch| 
        payload = { "records" => batch }
        log.debug "Sending batch of #{batch.size()} records to EventHub..."
        @sender.send_w_properties(payload, @message_properties)
      }
    end

  end
end
