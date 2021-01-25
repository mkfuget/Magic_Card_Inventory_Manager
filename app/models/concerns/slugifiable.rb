module Slugifiable
    module InstanceMethods
      def slug
        "#{self.name.parameterize}-#{self.id}"
      end
    end 
    module ClassMethods
      def find_by_slug(slug)
        all.find{|x| x.slug == slug}
      end
    end
  end 