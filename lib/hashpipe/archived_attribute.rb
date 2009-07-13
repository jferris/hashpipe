require 'activesupport'
require 'moneta'

module HashPipe

  class ArchivedAttribute
    attr_reader :name, :backend
    attr_accessor :scope

    def initialize(name, scope, backend, opts = {})
      @name    = name
      @scope   = scope
      @dirty   = false
      @options = HashPipe::GlobalConfiguration.instance.to_hash.merge(opts)
      @backend = backend
    end

    def value
      val = defined?(@stashed_value) ? @stashed_value : backend[key]
      val = compress? && !val.nil? ? Zlib::Inflate.inflate(val) : val
      val = marshal? ? Marshal.load(val) : val
    end

    def value=(other)
      other = marshal? ? Marshal.dump(other) : other
      other = compress? && !other.nil? ? Zlib::Deflate.deflate(other) : other
      @stashed_value = other
      @dirty = true
    end

    def dirty?
      @dirty
    end

    def save
      backend[key] = @stashed_value if self.dirty?
      @dirty = false
    end

    def destroy
      backend.delete(key)
    end

    def options
      @options
    end

    def key
      [scope, name].join('_')
    end

    [:marshal, :compress].each do |sym|
      define_method("#{sym}?") do                   # def marshal?
        options[sym].nil? ? false : options[sym]    #   options[:marshal].nil? ? false : options[:marshal]
      end                                           # end
    end

  end

end
