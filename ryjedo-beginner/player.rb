class Player

	def initialize
		@health = 20
	end

	def play_turn(warrior)
		if @health > warrior.health
			#im being attacked
			advance_and_attack(warrior)
		else
			#im not being attacked
			if warrior.health < 20
				warrior.rest!
			else
				advance_and_attack(warrior)
			end
		end
		@health = warrior.health
	end

	def advance_and_attack(warrior)
		if warrior.feel.enemy?
			warrior.attack!
		elsif warrior.feel.captive?
			warrior.rescue!
		elsif warrior.feel.empty?
			warrior.walk!
		end
	end

end
