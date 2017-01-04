function [schedule_fall, schedule_spring] = seminarscheduler(database, Nfall, Nspring)
% [SCHEDULE_FALL, SCHEDULE_SPRING]=SEMINARSCHEDULER(DATABASE, NFALL, NSPRING)
%
%   A small program suitable for scheduling neuro journal club
%   at Brandeis.
% 
%   Assumes DATABASE is a structure list with the following fields:
%        Name:  The person's name
%        Position:  Either 'PhD' or 'postdoc'
%        Lab:  The lab 
%        Fall_eligible:  0 or 1 (are they eligible to speak in the fall?)
%        Spring_eligible: 0 or 1 (are they eligible to speak in the spring?)
%        Spoke_last_year: 0 or 1 (did they speak last year?)
%        Molecular: 0 or 1 (are they interested in molecular biology)
%        Comments:  Any notes, like "make sure they speak in the spring", etc)
%       

database = database([randperm(length(database))]);  % shuffle the database so it has no particular order

speaking_fall = [];
speaking_spring = [];

  % Step 1: Identify all of the speakers who are obligated, that is, the PhD students:

obligated = [];

for i=1:length(database),
	str = upper(database(i).Position);
	str = str(find(str>=double('A')&str<=double('Z')));
	if strcmp(str,'PHD')
		obligated(end+1) = i;
	end;
end;

fall_eligible = find([database.Fall_eligible]==1);
spring_eligible = find([database.Spring_eligible]==1);

  % Step 2: Identify the obligated speakers who MUST speak in either the fall or spring

for i=1:length(obligated),
	if ismember(obligated(i),fall_eligible) & ~ismember(obligated(i),spring_eligible),
		speaking_fall(end+1) = obligated(i);
	elseif ~ismember(obligated(i),fall_eligible) & ismember(obligated(i),spring_eligible),
		speaking_spring(end+1) = obligated(i);
	end;
end;

  % Step 3: assign the remaining obligated speakers in a way that balances the remaining fall and spring slots

remaining_fall = Nfall - length(speaking_fall);
remaining_spring = Nspring - length(speaking_spring);
remaining_obligated = setdiff(obligated,union(speaking_fall,speaking_spring));

number_to_fall = ceil( length(remaining_obligated) * (remaining_fall / (remaining_fall+remaining_spring))  );  % put any extra person in the fall, since historically we have more eligible in the spring

speaking_fall = [speaking_fall remaining_obligated(1:number_to_fall)];
speaking_spring = [speaking_spring remaining_obligated(number_to_fall+1:end)];

 % Now we have the obligated speakers assigned

  % Step 4: Draw the remaining slots at random
       % There will be 2 lotteries; first, all fall eligible people will be drawn, then spring
       % People who did not speak last year will have a 4 times weight

remaining_fall = Nfall - length(speaking_fall);
remaining_spring = Nspring - length(speaking_spring);

if remaining_fall<0, error(['Too many obligated speakers for number of slots in fall.']); end;
if remaining_spring<0, error(['Too many obligated speakers for number of slots in spring.']); end;

  % okay, now fill out the list for fall:

fall_eligible = setdiff(find([database.Fall_eligible]==1),union(speaking_fall,speaking_spring));

actual_loadings = [];
for i=1:length(fall_eligible),
	if database(fall_eligible(i)).Spoke_last_year==1,
		actual_loadings(end+1) = fall_eligible(i);
	else,
		for j=1:500,
			actual_loadings(end+1) = fall_eligible(i);
		end;
	end;
end;

z = randperm(length(actual_loadings));

i = 1;
while (Nfall-length(speaking_fall)>0) & i<=length(z),
	if ~ismember(actual_loadings(z(i)),speaking_fall),
		speaking_fall(end+1) = actual_loadings(z(i));
	end;
	i = i + 1;
end;

spring_eligible = setdiff(find([database.Fall_eligible]==1),union(speaking_spring,speaking_fall));

actual_loadings = [];
for i=1:length(spring_eligible),
	if database(spring_eligible(i)).Spoke_last_year==1,
		actual_loadings(end+1) = spring_eligible(i);
	else,
		for j=1:500,
			actual_loadings(end+1) = spring_eligible(i);
		end;
	end;
end;

z = randperm(length(actual_loadings));

i = 1;
while (Nspring-length(speaking_spring)>0) & i<=length(z),
	if ~ismember(actual_loadings(z(i)),speaking_spring),
		speaking_spring(end+1) = actual_loadings(z(i));
	end;
	i = i + 1;
end;

schedule_fall = database(speaking_fall);
schedule_fall = schedule_fall(randperm(length(schedule_fall))); % shuffle order
schedule_spring = database(speaking_spring);
schedule_spring = schedule_spring(randperm(length(schedule_spring))); % shuffle order

