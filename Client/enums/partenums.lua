-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------


PARTICLE_CIRCLE_SIMPLE = function(psys)
	
	local x, y = 0, 0;
	local xR, yR, r = 0, 0, 1;
	for i = 1, #psys.LiveParticles do
		x, y = psys.LiveParticles[i]:GetPos();
		xR = r*math.cos(i)+x;
		yR = r*math.sin(i)+y;
		psys.LiveParticles[i]:SetPos(xR, yR);
	end
	
end

PARTICLE_CIRCLE_SIMPLE_REVERSED = function(psys)

	local x, y = 0, 0;
	local xR, yR, r = 0, 0, 1;
	for i = 1, #psys.LiveParticles do
		x, y = psys.LiveParticles[i]:GetPos();
		xR = r*math.sin(i)+x;
		yR = r*math.cos(i)+y;
		psys.LiveParticles[i]:SetPos(xR, yR);
	end
	
end