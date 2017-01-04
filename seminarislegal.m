function b = seminarislegal(schedule_fall, schedule_spring)
% B=SEMINARSISLEGAL(SCHEDULE_FALL, SCHEDULE_SPRING)
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
%    This function returns 1 if the schedule is "legal" (that is, everyone is able to 
%    present in that semester, and no postdocs spoke last year).
%    

b = 1;

for j=1:2,
	if j==1,
		schedule = schedule_fall;
		eligible_field = 'Fall_eligible';
	else, 
		schedule = schedule_spring;
		eligible_field = 'Spring_eligible';
	end;
	for i=1:length(schedule),
		if ~ getfield(schedule(i),eligible_field),
			b = 0;
			%disp(['person not semester eligible: ' int2str(i) ' in ' eligible_field '.']);
		end;
		if strcmp(upper(schedule(i).Position),'POSTDOC'),
			if schedule(i).Spoke_last_year,
				%disp(['person ' schedule(i).Name ' spoke last year']);
				%b = 0;
			end;
		end;
	end;
end;

