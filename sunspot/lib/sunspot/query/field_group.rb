module Sunspot
  module Query
    #
    # A FieldGroup groups by the unique values of a given field.
    #
    class FieldGroup
      attr_accessor :limit, :truncate, :ngroups

      def initialize(field)
        if field.multiple?
          raise(ArgumentError, "#{field.name} cannot be used for grouping because it is a multiple-value field")
        end
        @field = field
        @ngroups = false

        @sort = SortComposite.new
      end

      def add_sort(sort)
        @sort << sort
      end

      def to_params
        params = {
          :group            => "true",
          :"group.ngroups"  => @ngroups,
          :"group.field"    => @field.indexed_name
        }

        params.merge!(@sort.to_params("group."))
        params[:"group.limit"] = @limit if @limit
        params[:"group.truncate"] = @truncate if @truncate

        params
      end
    end
  end
end
