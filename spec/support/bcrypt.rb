require 'bcrypt'

module BCrypt
  class Engine
    class << self
      alias_method :_generate_salt, :generate_salt

      def generate_salt(_cost = MIN_COST)
        _generate_salt(MIN_COST)
      end
    end
  end
end
