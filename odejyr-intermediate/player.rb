class Player

	def play_turn(warrior)
    
		if locate_enemy(warrior) == :empty
			if warrior.health == 20
				warrior.walk!(warrior.direction_of_stairs)
			else
				warrior.rest!
			end
		else
			warrior.attack!(locate_enemy(warrior))
		end
	end


	def locate_enemy(warrior)

		return_value = :nil

		if warrior.feel(:forward).enemy?
			return_value = :forward
		elsif warrior.feel(:left).enemy?
			return_value = :left
		elsif warrior.feel(:right).enemy?
			return_value = :right
		elsif warrior.feel(:backward).enemy?
			return_value = :backward
		else
			return_value = :empty
		end	
		
		return return_value

	end


end
