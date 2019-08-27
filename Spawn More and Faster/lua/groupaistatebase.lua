function GroupAIStateBase:_get_balancing_multiplier(balance_multipliers)
	return balance_multipliers[#balance_multipliers]
end

Hooks:PostHook(GroupAIStateBase, "set_difficulty", "SMF_GroupAIStateBase_set_difficulty", function(self)
	self._difficulty_value = 1
	self:_calculate_difficulty_ratio()
end)