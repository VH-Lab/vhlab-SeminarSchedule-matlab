function [dates,datenums] = classdays(semester_start, semester_end, meet_days, exceptions)
% CLASSDAYS - Return and print class days for a semester course
%
%   [DATES,DATENUMS] = CLASSDATES(SEMESTER_START, SEMESTER_END, MEET_DAYS, EXCEPTIONS)
%
%   Prints (and returns in DATES) the dates that a class will be held given
%   that it starts on SEMESTER_START and ends on SEMESTER_END. Both SEMESTER_START
%   and SEMESTER_END should be date strings of the form '2015-01-01'.
%   MEET_DAYS should be a cell array of strings that describes the dates the class
%   will meet. 
%
%   DATES is a cell array of date strings of class meetings.
%
%   EXCEPTIONS is a structure array of exceptions, with fields 'exception_name',
%   'date1', and 'date2'. Valid values for the 'exception_name' field are as follows:
%   IF exception_name is 'recess'
%   	'date1' and 'date2' should date strings (same format as above) of the
%        beginning and end of the recess.  The beginning and end dates have no class.
%        If 'date2' is empty, then the recess is assumed to be a single day.
%        If 'date1' is a cell list of strings, then it is assumed that there are multiple
%        single day recesses.
%   If exception name is 'substitution', 'date1' should be the date that is to be
%        substituted, and 'date2' should be the day of the week for which the substituted
%        date stands in.
%
%   Example: Schedule a class that meets Wednesdays in a semester that begins
%     2015-08-27 and ends 2015-12-09, has no class on Sept. 7, Sept. 14-15,
%     Sept. 23, Sept. 28, Oct. 5, Nov. 25-27, and observes a 'Monday' schedule
%     on Sept. 10 and Sept. 29.
%
%     semester_start = '2015-08-27';
%     semester_end   = '2015-12-09';
%     meet_days = {'Wednesday'};
%     exceptions = struct('exception_name','recess',...
%         'date1',{{'2015-09-07','2015-09-23','2015-09-28','2015-10-05'}},'date2',[]);
%     exceptions(2) = struct('exception_name','recess', ...
%         'date1','2015-09-14','date2','2015-09-15'); 
%     exceptions(3) = struct('exception_name','recess', ...
%         'date1','2015-11-25','date2','2015-11-27');
%     exceptions(4) = struct('exception_name','substitution','date1','2015-09-10',...
%	  'date2','Monday');
%     exceptions(5) = struct('exception_name','substitution','date1','2015-09-29',...
%	  'date2','Monday');
%     [dates,datenums] = classdays(semester_start,semester_end,meet_days,exceptions);
%     dates'
%

dates = {};
datenums = [];

n1 = datenum(semester_start);
n2 = datenum(semester_end);

for i=1:length(meet_days), % make sure days of week are capital first letters
	meet_days{i} = [upper(meet_days{i}(1)) lower(meet_days{i}(2:end))];
end;

for n=n1:n2,
	% first, ask, is this day during a recess?

	is_recess = 0;
	for i=1:length(exceptions),
		if strcmp(lower(exceptions(i).exception_name),'recess'),
			if isempty(exceptions(i).date2), % single day
				if iscell(exceptions(i).date1), % a cell array
					for j=1:length(exceptions(i).date1),
						rn = datenum(exceptions(i).date1{j});
						if rn==n,
							is_recess = 1;
						end;
					end;
				else,
					rn = datenum(exceptions(i).date1);
					if rn==n,
						is_recess = 1;
					end;
				end;
			else, % range of days
				rn1 = datenum(exceptions(i).date1);
				rn2 = datenum(exceptions(i).date2);
				if n>=rn1 & n<=rn2,
					is_recess = 1;
				end;
			end;
		end;
	end;

	% what day of the week is this day? Is it an exception day such that it acts like another day?

	[daynum,dayname] = weekday(n,'long');
	for i=1:length(exceptions),
		if strcmp(exceptions(i).exception_name,'substitution'),
			s1 = datenum(exceptions(i).date1);
			if n==s1,
				dayname = [upper(exceptions(i).date2(1)) lower(exceptions(i).date2(2:end))];
			end;
		end;
	end;

	if ~is_recess & ismember(dayname,meet_days);  % do we meet today??
		datenums(end+1) = n;
		dates{end+1} = datestr(n,'ddd mm/dd');
	end;
end;


