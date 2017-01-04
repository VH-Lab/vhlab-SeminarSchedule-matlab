function f = seminarfitness(schedule_fall, schedule_spring)
% F=SEMINARFITNESS(SCHEDULE_FALL, SCHEDULE_SPRING)
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
%    The seminar fitness is calculated. If the 2 speakers are of different disciplines
%    (different values of 'Molecular') then 2 points are awarded. If the 2 speakers are
%    of different positions, then 1 point is awarded.
%       

f = 0;

for j=1:2,
	if j==1,
		schedule = schedule_fall;
		eligible_field = 'Fall_eligible';
	else, 
		schedule = schedule_spring;
		eligible_field = 'Spring_eligible';
	end;
	for i=1:2:length(schedule),
		if schedule(i).Molecular~=schedule(i+1).Molecular,
			f = f+2;
		end;
		if ~strcmp(upper(schedule(i).Position),upper(schedule(i+1).Position)),
			f = f + 1;
		end;
	end;
end;

