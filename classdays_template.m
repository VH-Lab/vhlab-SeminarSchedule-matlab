function classdays_template
% CLASSDAYS_TEMPLATE - Editable template to schedule class meetings at Brandeis

fall_semester_start = '2017-08-30';
fall_semester_end   = '2017-12-11';

jc_meet_days = {'Wednesday'};
bio107_meet_days = {'Tuesday','Thursday'};
%nbio145b_meet_days = {'Tuesday','Thursday'};

fall_exceptions = struct('exception_name','recess',...
	'date1',{'2017-09-04','2017-09-21','2017-09-22','2017-10-05',...
		'2017-10-12' },'date2',[]);
fall_exceptions(2) = struct('exception_name','recess', ...
	'date1','2017-11-22','date2','2017-11-24');
fall_exceptions(3) = struct('exception_name','substitution','date1','2017-10-03',...
	'date2','Thursday');
fall_exceptions(4) = struct('exception_name','substitution','date1','2017-10-11',...
	'date2','Thursday');


spring_semester_start = '2018-01-10';
spring_semester_end   = '2018-04-26';

spring_exceptions = struct('exception_name','recess', ...
	'date1',{'2018-01-15'},'date2',[]);
spring_exceptions(2) = struct('exception_name','recess', ...
	'date1','2018-02-19','date2','2018-02-23');
spring_exceptions(3) = struct('exception_name','recess', ...
	'date1','2018-03-30','date2','2018-04-06');
spring_exceptions(4) = struct('exception_name','substitution','date1','2018-01-18',...
	'date2','Monday');
spring_exceptions(5) = struct('exception_name','substitution','date1','2018-04-26',...
	'date2','Friday');

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

%[nbio145bdates,datenums] = classdays(spring_semester_start,spring_semester_end,...
%		nbio145b_meet_days, spring_exceptions);

disp(['JC Spring dates']);
jcspringdates'

%disp(['Nbio145b dates'])
%nbio145bdates'


