
fmax = 0;

database = loadStructArray('JournalClub20172018.txt'),

for i=1:100,
	i,
	[schedule_fall,schedule_spring] = seminarscheduler(database,11*2,13*2);
	[schedule_fall_new,schedule_spring_new,f] = seminaroptimizer(schedule_fall,schedule_spring);
	if f>fmax,
		W=workspace2struct;
		fmax = f;
	end;
end;

 % now pick 6 alternates

allnames = union({W.schedule_fall_new.Name},{W.schedule_spring_new.Name});

inds_nolastyear = [];
inds_lastyear = [];
for i=1:length(database),
	if strcmp(upper(database(i).Position),upper('postdoc')),
		if ~any(strcmp(allnames,database(i).Name))
			if database(i).Spoke_last_year==0,
				inds_nolastyear(end+1) = i;
			else,
				inds_lastyear(end+1) = i;
			end;
		end;
	end;
end;


disp(['Fall schedule']);
for i=1:2:length(W.schedule_fall_new),
	disp([W.schedule_fall_new(i).Name ' (' W.schedule_fall_new(i).Lab '); ' W.schedule_fall_new(i+1).Name ' (' W.schedule_fall_new(i+1).Lab ')']);
end;

disp(['Spring schedule']);
for i=1:2:length(W.schedule_spring_new),
	disp([W.schedule_spring_new(i).Name ' (' W.schedule_spring_new(i).Lab '); ' W.schedule_spring_new(i+1).Name ' (' W.schedule_spring_new(i+1).Lab ')']);
end;

disp('Alternates who did not speak last year');
database(inds_nolastyear(randperm(length(inds_nolastyear)))).Name
disp('Alternates who did speak last year');
database(inds_lastyear(randperm(length(inds_lastyear)))).Name

