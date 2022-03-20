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
	
	
	
end)