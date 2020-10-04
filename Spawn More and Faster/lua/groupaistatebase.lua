if GroupAIStateBase then
	function GroupAIStateBase:_get_balancing_multiplier(balance_multipliers)
		return balance_multipliers[#balance_multipliers]
	end
	Hooks:PostHook(GroupAIStateBase, "set_difficulty", "SMF_GroupAIStateBase_set_difficulty", function(self)
		self._difficulty_value = 1
		self:_calculate_difficulty_ratio()
	end)
end

if GroupAIStateBesiege then
	function GroupAIStateBesiege:_get_balancing_multiplier(balance_multipliers)
		return balance_multipliers[#balance_multipliers]
	end
	if GroupAIStateBesiege.set_difficulty then
		Hooks:PostHook(GroupAIStateBesiege, "set_difficulty", "SMF_GroupAIStateBesiege_set_difficulty", function(self)
			self._difficulty_value = 1
			self:_calculate_difficulty_ratio()
		end)
	end
end

if GroupAIStateStreet then
	function GroupAIStateStreet:_get_balancing_multiplier(balance_multipliers)
		return balance_multipliers[#balance_multipliers]
	end
	if GroupAIStateStreet.set_difficulty then
		Hooks:PostHook(GroupAIStateStreet, "set_difficulty", "SMF_GroupAIStateStreet_set_difficulty", function(self)
			self._difficulty_value = 1
			self:_calculate_difficulty_ratio()
		end)
	end
end