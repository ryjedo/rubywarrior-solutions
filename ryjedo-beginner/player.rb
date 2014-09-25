class Player

	def initialize
		@health = 20
		@enough_health = 10
		@found_far_wall = false
	end

	def play_turn(warrior)
		if @health > warrior.health #i'm being attacked
			if warrior.health > @enough_health #i have enough health to press the attack
				advance_forward(warrior)
			else #i'm low on health and must retreat
				warrior.walk!(:backward)
			end
		else #i'm not being attacked
			if warrior.health < 20 #I'm not full health
				warrior.rest!
			else #i am full health
				advance_forward(warrior)
			end
 		end
		@health = warrior.health
	end

	def advance_forward(warrior)
		direction = :forward
		case detect_space_type(warrior.feel(direction))
		when :empty
			warrior.walk!(direction)
		when :enemy
			warrior.attack!(direction)
		when :captive
			warrior.rescue!(direction)
		when :wall
			warrior.pivot!(:backward)
			@found_far_wall = true
		when :stairs
			if @found_far_wall == true
				warrior.walk!(direction)
			else
				warrior.pivot!(:backward)
			end
		end
	end

=begin
	def advance_backward(warrior)
		direction = :backward
		case detect_space_type(warrior.feel(direction))
		when :empty 
			warrior.walk!(direction)
		when :enemy
			warrior.attack!(direction)
		when :captive
			warrior.rescue!(direction)
		when :wall
			@found_level_start = true
		end
	end
=end

	def detect_space_type(space)
		
		if space.empty?
			return :empty
		
		elsif space.enemy?
			return :enemy
		
		elsif space.captive?
			return :captive
		
		elsif space.wall?
			return :wall
		
		elsif space.stairs?
			return :stairs
		
		else
			return :unkown_space
		end
	end

end
