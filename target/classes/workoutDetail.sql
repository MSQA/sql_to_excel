select
    t4.fullname,
    t1.seq as eventNO,
    t6.title,
	step_num,
    case
		when step_type = 1 then 'WARM_UP'
        when step_type = 2 then 'COOL_DOWN'
        when step_type = 3 then 'RUN'
        when step_type = 5 then 'REST'
        when step_type = 4 then 'RECOVERY'
        when step_type = 7 then 'OTHER'
        when step_type = 255 then 'INVALID'
	end as step_type,
    ifnull(concat(truncate(t5.reaching_rate*100,2),'%'),'N/A') as reaching_rate,
    substring_index(sec_to_time(duration/1000),':',-2) as time,
    ifnull(truncate(distance/100000,2),'N/A') as distance,
    substring_index(sec_to_time((duration/1000)/(distance/100000)),':',-2) as 'AVG_PACE',
    ifnull(avg_heart_rate,'N/A') as 'Avg HR',
    ifnull(max_heart_rate,'N/A') as 'Max HR',
    ifnull(elevation_gain,'N/A') as 'Elev Gain',
    ifnull(avg_run_cadence,'N/A') as 'Avg Cadence',
    ifnull(truncate(avg_vertical_oscillation,2),'N/A') as 'Avg Vertical Oscillation',
    ifnull(truncate(avg_ground_contact_time,2),'N/A') as 'Avg Ground Contact Time',
    ifnull(truncate(calories,2),'N/A') as calories,
    ifnull(truncate(avg_vertical_ratio,2),'N/A') as 'Avg Vertical Ratio',
    ifnull(concat(concat(concat('L',truncate(avg_ground_contact_balance,2)),'/'),concat('R',100-truncate(avg_ground_contact_balance,2))),'N/A') as 'Avg GCT Balance'
from
	training_event t1
		join
	attendance_record t2 on t1.training_event_id = t2.training_event_id
		join
	training_report t3 on t2.attendance_activity_id = t3.activity_id and t2.training_event_id = t3.training_event_id
		join
	gcc_user t4 on t2.gcc_user_id = t4.gcc_user_id
		join
	workout_step_summary t5 on t3.training_report_id = t5.training_report_id
		join
	training_event_type t6 on t1.training_course_id = t6.training_course_id and t1.training_event_type_id = t6.training_event_type_id
where
	t1.training_course_id = ?
ORDER BY
  t4.fullname;


