Hooks:Add("LoadQuickAnimateLibrary","MHUDU_AddQuickAnimateLibrary",function(parent)
	function parent.animate_gradient_scroll(o,t,dt,start_t,duration,col_1,col_2)
		local progress = (t - start_t) / duration
		local progress_sq = progress * progress
		
		o:set_gradient_points({
			0,col_1,
			math.max(progress_sq,0.01),col_1:with_alpha(0.5),
			1,col_2
		})
		if progress >= 1 then 
			return true
		end
	end
	
	function parent.animate_move_sq(o,t,dt,start_t,duration,from_x,to_x,from_y,to_y)
		local ratio = math.pow((t - start_t) / duration,2)
		
		if ratio >= 1 then 
			if to_x then 
				o:set_x(to_x)
			end 
			if to_y then 
				o:set_y(to_y)
			end
			return true
		end
		if from_x and to_x then 
			o:set_x(from_x + ((to_x - from_x) * ratio))
		end
		if from_y and to_y then 
			o:set_y(from_y + ((to_y - from_y) * ratio))
		end
	end
	
	function parent.animate_move_simple(o,t,dt,start_t,duration,from_x,to_x,from_y,to_y)
		local ratio = (t - start_t) / duration
		
		if ratio >= 1 then 
			if to_x then 
				o:set_x(to_x)
			end 
			if to_y then 
				o:set_y(to_y)
			end
			return true
		end
		if from_x and to_x then 
			o:set_x(from_x + ((to_x - from_x) * ratio))
		end
		if from_y and to_y then 
			o:set_y(from_y + ((to_y - from_y) * ratio))
		end
	end
	
	
end)