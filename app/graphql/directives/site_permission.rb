# frozen_string_literal: true

class Directives::SitePermission < GraphQL::Schema::Directive
  description 'Ensure the current user has the necessary site permission to access a resource'

  locations FIELD_DEFINITION, OBJECT, SCALAR, ENUM, UNION, INTERFACE, INPUT_OBJECT, ENUM_VALUE,
    ARGUMENT_DEFINITION, INPUT_FIELD_DEFINITION

  argument :required, String, required: true,
    description: 'The required permission'

  def initialize(target, required:)
    mod = module_for(target, required:)
    target.singleton_class.include(mod)
    super(target, required:)
  end

  # Generate the mixin module
  def module_for(target, required:)
    required = required.to_sym
    Module.new.tap do |mod|
      mod.singleton_class.define_method(:inspect) do
        "#<Directives::SitePermission#module_for(#{target.inspect})>"
      end

      mod.define_method(:visible?) do |context|
        puts '-------'
        pp 'REQUIRED', required
        pp 'TARGET', target
        pp 'CONTEXT', context.to_h
        pp 'VISIBLE?', context[:site_permissions]&.include?(required)
        puts '^^^^^^^'
        context[:show_all] || context[:site_permissions]&.include?(required)
      end

      if target.is_a?(GraphQL::Schema::Field)
        mod.define_method(:authorized?) do |object, args, context|
          super(object, args, context) && context[:site_permissions]&.include?(required)
        end
      elsif target < GraphQL::Schema::Object || target < GraphQL::Schema::Mutation
        mod.define_method(:authorized?) do |object, context|
          super(object, context) && context[:site_permissions]&.include?(required)
        end
      else
        raise ArgumentError, "Unsupported target: #{target.ancestors.join(' < ')}"
      end
    end
  end
end
