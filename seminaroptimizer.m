function [schedule_fall_new, schedule_spring_new,F] = seminaroptimizer(schedule_fall, schedule_spring)
% [SCHEDULE_FALL_NEW, SCHEDULE_SPRING_NEW]=SEMINARSCHEDULER(SCHEDULE_FALL, SCHEDULE_SPRING)
%
%   A small program suitable for scheduling neuro journal club
%   at Brandeis.
% 
%   Assumes SCHEDULE_FALL and SCHEDULE_SPRING is a structure list with the following fields:
%        Name:  The person's name
%        Position:  Either 'PhD' or 'postdoc'
%        Lab:  The lab 
%        Fall_eligible:  0 or 1 (are they eligible to speak in the fall?)
%        Spring_eligible: 0 or 1 (are they eligible to speak in the spring?)
%        Spoke_last_year: 0 or 1 (did they speak last year?)
%        Molecular: 0 or 1 (are they interested in molecular biology)
%
%    It also assumes that there are 2 speakers per session, sequentially in the list (that is,
%    the schedule list should be an even number).     
%
%    Changes are made as long as they are 1) legal (SEMINARISLEGAL) and 2) maximize seminar
%    fitness (SEMINARFITNESS).
%       

Nfall = length(schedule_fall);
Nspring = length(schedule_spring);

schedule_fall_new = schedule_fall;
schedule_spring_new = schedule_spring;

F = seminarfitness(schedule_fall_new,schedule_spring_new);

% try replacements

for i=1:1000,
	schedule_fall_temp = schedule_fall_new;
	schedule_spring_temp = schedule_spring_new;
	R = randperm(Nfall+Nspring);
	r1 = R(1);
	r2 = R(2);
	if r1>Nfall&r2>Nfall,
		% swap 2 within spring
		r1 = r1 - Nfall;
		r2 = r2 - Nfall;
		schedule_spring_temp(r1) = schedule_spring_new(r2);
		schedule_spring_temp(r2) = schedule_spring_new(r1);
	elseif r1>Nfall&r2<=Nfall,
		r1 = r1 - Nfall;
		schedule_spring_temp(r1) = schedule_fall_new(r2);
		schedule_fall_temp(r2) = schedule_spring_new(r1);
	elseif r1<=Nfall&r2>Nfall,
		r2 = r2 - Nfall;
		schedule_spring_temp(r2) = schedule_fall_new(r1);
		schedule_fall_temp(r1) = schedule_spring_new(r2);
	elseif r1<=Nfall&r2<=Nfall,
		schedule_fall_temp(r1) = schedule_fall_new(r2);
		schedule_fall_temp(r2) = schedule_fall_new(r1);
	else,
		error(['how did we get here?']);
	end;

	if seminarislegal(schedule_fall_temp, schedule_spring_temp),
		Fcurrent = seminarfitness(schedule_fall_temp,schedule_spring_temp);
		if Fcurrent>F,
			schedule_fall_new = schedule_fall_temp;
			schedule_spring_new = schedule_spring_temp;
			F = Fcurrent;
		end;
	end;

end;



