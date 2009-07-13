require File.expand_path(File.join(File.dirname(__FILE__), %w[hashpipe archived_attribute] ))
require File.expand_path(File.join(File.dirname(__FILE__), %w[hashpipe global_configuration] ))

module HashPipe

  def self.included(base)
    base.extend(SingletonMethods)
  end

  module SingletonMethods

    def hattr(*args)
      attribute = args.first

      options = args.extract_options!
      options.reverse_merge! :marshalled => false

      if archived_attribute_definitions.nil?
        write_inheritable_attribute(:archived_attribute_definitions, {})

        after_save :save_archived_attributes
        before_destroy :destroy_archived_attributes
      end

      archived_attribute_definitions[attribute] = options

      include InstanceMethods

      define_method attribute do
        archive_stash_for(attribute).value
      end

      define_method "#{attribute}=" do |value|
        archive_stash_for(attribute).value = value
      end
    end

    # Returns the attachment definitions defined by each call to
    # has_attached_file.
    def archived_attribute_definitions
      read_inheritable_attribute(:archived_attribute_definitions)
    end

    def backend
      @backend ||= initialize_cache_klass(HashPipe::GlobalConfiguration.instance[:moneta_klass])
    end

    def initialize_cache_klass(cache_klass)
      require_moneta_library_for(cache_klass)
      klass_const = cache_klass.respond_to?(:constantize) ? cache_klass.constantize : cache_klass
      klass_const.new HashPipe::GlobalConfiguration.instance[:moneta_options]
    end

    def require_moneta_library_for(cache_klass)
      require cache_klass.to_s.gsub(/::/, '/').downcase
    end
  end

  module InstanceMethods
    def archive_stash_for(attribute)
      @_archived_attribute_stashes ||= {}
      @_archived_attribute_stashes[attribute] ||= ArchivedAttribute.new(
        attribute,
        archived_attribute_scope,
        self.class.backend,
        self.class.archived_attribute_definitions[attribute]
      )
    end

    def archived_attribute_scope
      "#{self.class.table_name}_#{id}"
    end

    def each_archived_stash
      self.class.archived_attribute_definitions.each do |name, definition|
        yield(name, archive_stash_for(name))
      end
    end

    def save_archived_attributes
      each_archived_stash do |name, stash|
        stash.scope = archived_attribute_scope
        stash.save
      end
    end

    def destroy_archived_attributes
      each_archived_stash do |name, stash|
        stash.destroy
      end
    end

  end
end

ActiveRecord::Base.send(:include, HashPipe)
