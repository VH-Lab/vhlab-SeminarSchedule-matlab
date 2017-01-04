function classdays_template
% CLASSDAYS_TEMPLATE - Editable template to schedule class meetings at Brandeis

fall_semester_start = '2016-08-25';
fall_semester_end   = '2016-12-07';

jc_meet_days = {'Wednesday'};
bio107_meet_days = {'Monday','Wednesday'};
nbio145b_meet_days = {'Tuesday','Thursday'};

fall_exceptions = struct('exception_name','recess',...
	'date1',{{'2016-09-05','2016-10-03','2016-10-04','2016-10-12',...
		{'2016-10-17','2016-10-24'} }},'date2',[]);
fall_exceptions(2) = struct('exception_name','recess', ...
	'date1','2016-11-23','date2','2016-11-25');
fall_exceptions(3) = struct('exception_name','substitution','date1','2016-09-08',...
	'date2','Monday');
fall_exceptions(4) = struct('exception_name','substitution','date1','2016-10-25',...
	'date2','Monday');


spring_semester_start = '2017-01-17';
spring_semester_end   = '2017-05-03';

spring_exceptions = struct('exception_name','recess', ...
	'date1','2017-02-20','date2','2017-02-24');
spring_exceptions(2) = struct('exception_name','recess', ...
	'date1','2017-04-10','date2','2017-04-18');
spring_exceptions(3) = struct('exception_name','substitution','date1','2016-04-19',...
	'date2','Monday');

[bio107dates,datenums] = classdays(fall_semester_start,fall_semester_end,...
		bio107_meet_days,fall_exceptions);

disp(['Bio107a dates']);
bio107dates',

[jcfalldates,datenums] = classdays(fall_semester_start,fall_semester_end,...
		jc_meet_days, fall_exceptions);

disp(['JC Fall dates']);
jcfalldates',

[jcspringdates,datenums] = classdays(spring_semester_start,spring_semester_end,...
		jc_meet_days, spring_exceptions);

[nbio145bdates,datenums] = classdays(spring_semester_start,spring_semester_end,...
		nbio145b_meet_days, spring_exceptions);

disp(['JC Spring dates']);
jcspringdates'

disp(['Nbio145b dates'])
nbio145bdates'


