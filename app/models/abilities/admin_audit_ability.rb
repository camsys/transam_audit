module Abilities
  class AdminAuditAbility
    include CanCan::Ability

    def initialize(user)

      cannot :create, Audit   # temporarily disallow creation since creating customized audit not implemented y

      cannot :destroy, Activity do |a|
      (a.system_activity == true) || Audit.pluck(:activity_id).include? a.id
      end

    end
  end
end