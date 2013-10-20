proc(_filter_login,@player,
	if(_time_left(@player) <= 0,
		if(has_permission(@player,'hermitcraft.hermit'),
			return(false)
		)
		console('Player needs to be kicked!')
		return(true),
		console('Player still has time left!')
		return(false)
	)
	return(false)
)

proc(_interval,
	set_interval(1000,
		closure(_run_on_interval())
	)
)

proc(_run_on_interval,
	foreach(all_players(),@player,
		if(_time_left(@player) <= 0,
			if(not(has_permission(@player,'hermitcraft.hermit')),
				pkick(@player,'You ran out of time!')
			)
		)
		if(not(has_permission(@player,'hermitcraft.hermit')),
			_update_scoreboard(@player)
		)
	)
)

proc(_update_scoreboard,@player,
	assign(@timeleft,_time_left(@player))
	assign(@minutes_left,_to_friendly_time(@timeleft)[0])
	assign(@boardname,concat(@player,'_sb'))
	assign(@boards,get_scoreboards())
	assign(@objectivename,'Minutes Left')	
	if(not(array_contains_ic(@boards,@boardname)),
		create_scoreboard(@boardname)
		set_pscoreboard(@player,@boardname)
	)
	assign(@objectives,get_objectives(@boardname))
	assign(@exists,'false')
	foreach(@objectives,@o_array,
		if(equals(@o_array['displayname'],@objectivename),
			assign(@exists,'true')
		)
	)
	if(equals(@exists,'false'),
		msg('false')
		create_objective(@objectivename,'dummy',@boardname)
		assign(@displayinfo,array(displayname: 'Minutes Left',slot: 'SIDEBAR'))
		set_objective_display(@objectivename,@displayinfo,@boardname)
	)
	set_pscore(@objectivename,@player,@minutes_left,@boardname)

)

proc(_time_left,@player,
	assign(@time,time())
	assign(@allowed_minutes,5)
	assign(@allowed_time,@allowed_minutes * 60 * 1000)
	assign(@time_passed, @time - _first_login(@player))
	assign(@time_left, @allowed_time - @time_passed)
	return(@time_left)
)

proc(_first_login,@player,
	assign(@time,time())
	assign(@l_player,to_lower(@player))
	assign(@first_login,get_value(concat(@l_player,'_first_login')))
	if(length(@first_login) < 8,
		store_value(concat(@l_player,'_first_login'),@time)
		assign(@first_login,time())
	)
	return(@first_login)		
)

proc(_to_seconds,@milliseconds,
	assign(@seconds,round(divide(@milliseconds,1000),0))
	return(@seconds)
)

proc(_to_minutes,@seconds,
	assign(@minutes,round(divide(@seconds,60),0))
	return(@minutes)
)

proc(_to_friendly_time,@milliseconds,
	assign(@minutes,0)
	assign(@seconds,0)
	if(@milliseconds > 1000,
		assign(@seconds,integer(_to_seconds(@milliseconds)))
		assign(@milliseconds,mod(@milliseconds,1000)),
		assign(@seconds,0)
	)
	if(@seconds > 60,
		assign(@minutes,_to_minutes(@seconds))
		assign(@seconds,mod(@seconds,60)),
		assign(@seconds,@seconds)
	)
	assign(@ret,array(@minutes,@seconds,@milliseconds))
	return(@ret)
)
