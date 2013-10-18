proc(_check_group,@player,@group,
	#if player is not in group, cancel all further actions
	if(not(array_contains(pgroup(@player),@group)),
		die(color('red'),'Invalid Permissions')
	)
	return()
)

proc(_check_permission,@player,@node,
	#if player does not have permission node, cancel all further actions
	if(not(has_permission(@player,@node)),
		die(color('red'),'Invalid Permissions')
	)
	return()
)