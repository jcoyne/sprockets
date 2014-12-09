require '6to5'

module Sprockets
  class ES6to5Processor
    VERSION = '1'
    SOURCE_VERSION = ::ES6to5.version

    def self.instance
      @instance ||= new
    end

    def self.call(input)
      instance.call(input)
    end

    def initialize(options = {})
      @options = {blacklist: []}.merge(options)
      @options[:blacklist] << 'useStrict'
      @options[:sourceMap] = true

      @cache_key = [
        self.class.name,
        SOURCE_VERSION,
        VERSION,
        @options
      ]
    end

    def call(input)
      data = input[:data]

      result = input[:cache].fetch(@cache_key + [data]) do
        ES6to5.transform(data, @options)
      end

      result['code']
    end
  end
end
