class Player

	def initialize
		
		@found_far_wall = false
		@area_assumed_safe = false
		@starting_orientation_reversed = false

	end


	def play_turn(warrior)

		#quite possibly the ugliest, and least general-case solution possible. 
		#done this way because its impossible to tell ranged enemy's from melee enemys in code.
		#there may be a more elegant solution, but not likely one elegant enough to warrant the time spent.
		if @starting_orientation_reversed == false
			warrior.pivot!(:backward)
			@starting_orientation_reversed = true
		elsif @area_assumed_safe == true
			advance_forward(warrior)
		else
			detect_and_attack_enemies(warrior)
		end
	
	end


	def detect_and_attack_enemies(warrior)

		view_forward = identify_viewable_spaces(warrior.look(:forward))
		view_backward = identify_viewable_spaces(warrior.look(:backward))

		#check forward direction
		if direction_is_safe?(view_forward)
			#check other direction
			if direction_is_safe?(view_backward)
				#assume area is safe
				@area_assumed_safe = true
				advance_forward(warrior)
			else
				#attack that direction
				attack_enemy(view_backward, :backward, warrior)
			end
		else
			#attack that direction
			attack_enemy(view_forward, :forward, warrior)
		end
	
	end


	def advance_forward(warrior)
	
		if warrior.health < 20
			warrior.rest!
		else
			viewable_spaces = identify_viewable_spaces(warrior.look(:forward))
		
			case viewable_spaces.first
			when :captive
				warrior.rescue!(:forward)
				@area_assumed_safe = false
			when :wall
				warrior.pivot!(:backward)
				@found_far_wall = true
			when :stairs
				if @found_far_wall == true
					warrior.walk!(:forward)
				else
					warrior.pivot!(:backward)
				end
			when :empty
				warrior.walk!(:forward)
				@area_assumed_safe = false
			end

		end
	
	end


	def direction_is_safe?(viewable_symbols)
	
		i=0
		result = false
	
		while i < 3 do
			if viewable_symbols[i] == :enemy
				result = false
				i = 3
			elsif i == 2 && viewable_symbols[2] == :empty
				i = 3
				result = true
			elsif viewable_symbols[i] == :empty
				#continue searching
				i+=1		
			else
				#if it finds anything else, it must be safe
				i = 3
				result = true
			end
		end
		
		return result
	
	end


	def attack_enemy(viewable_symbols, direction, warrior)
		
		if viewable_symbols.first == :enemy
			warrior.attack!(direction)
		else
			warrior.shoot!(direction)
		end
	
	end


		#parses warrior.look array and converts to symbols.
	def identify_viewable_spaces(viewable_spaces)
		
		viewable_symbols = Array.new

		viewable_spaces.each { |viewable_space|
			
			if viewable_space.stairs?
				viewable_symbols.push(:stairs)
			
			elsif viewable_space.enemy?
				viewable_symbols.push(:enemy)
			
			elsif viewable_space.captive?
				viewable_symbols.push(:captive)
			
			elsif viewable_space.wall?
				viewable_symbols.push(:wall)
			
			elsif viewable_space.empty?
				viewable_symbols.push(:empty)
			
			else
				viewable_symbols.push(:unkown_space)
			
			end 
		}
	
		return viewable_symbols
	
	end

end