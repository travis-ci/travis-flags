require 'active_record'

class Repository < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
end
Repo = Repository

class Organization < ActiveRecord::Base
end
Org = Organization

class User < ActiveRecord::Base
end
