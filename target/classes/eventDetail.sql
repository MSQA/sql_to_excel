SELECT
    t6.fullname as 'Name',
    t1.seq as 'Event No.',
    DATE(t1.start_time) as 'Date',
	t2.title as 'Event Type',
	case when (t5.attendance_record_id) > 0 then 1 else 0 end as 'Attendance(Present:1;Absent:0)',
    IFNULL(t4.gc_workout_name, 'N/A') as 'Workout Name',
	case
		when t7.training_report_id is null then 'N/A'
        when t7.training_report_id is not null then (select concat(truncate(avg(reaching_rate)*100,2),'%') from training_report where training_report_id = t7.training_report_id group by training_report_id )
    end as Total,
    case
		when t7.training_report_id is null then 'N/A'
        when t7.training_report_id is not null then (select concat(truncate(avg(reaching_rate)*100,2),'%') from workout_step_summary where training_report_id = t7.training_report_id and step_type = 1 group by training_report_id)
    end as WarmUp,
    case
		when t7.training_report_id is null then 'N/A'
        when t7.training_report_id is not null then (select concat(truncate(avg(reaching_rate)*100,2),'%') from workout_step_summary where training_report_id = t7.training_report_id and step_type = 2 group by training_report_id)
    end as Run,
    case
		when t7.training_report_id is null then 'N/A'
        when t7.training_report_id is not null then (select concat(truncate(avg(reaching_rate)*100,2),'%') from workout_step_summary where training_report_id = t7.training_report_id and step_type = 3 group by training_report_id)
    end as 'Recover',
    case
		when t7.training_report_id is null then 'N/A'
        when t7.training_report_id is not null then (select concat(truncate(avg(reaching_rate)*100,2),'%') from workout_step_summary where training_report_id = t7.training_report_id and step_type = 4 group by training_report_id)
    end as Rest,
    case
		when t7.training_report_id is null then 'N/A'
        when t7.training_report_id is not null then (select concat(truncate(avg(reaching_rate)*100,2),'%') from workout_step_summary where training_report_id = t7.training_report_id and step_type = 5 group by training_report_id)
    end as CoolDown,
    case
		when t7.training_report_id is null then 'N/A'
        when t7.training_report_id is not null then (select concat(truncate(avg(reaching_rate)*100,2),'%') from workout_step_summary where training_report_id = t7.training_report_id and step_type = 7 group by training_report_id)
    end as Other,
    ifnull(substring_index(sec_to_time(t8.time_in_heart_rate_zone1/1000),':',-2),'N/A') as Z1,
    ifnull(substring_index(sec_to_time(t8.time_in_heart_rate_zone2/1000),':',-2),'N/A') as Z2,
    ifnull(substring_index(sec_to_time(t8.time_in_heart_rate_zone3/1000),':',-2),'N/A') as Z3,
    ifnull(substring_index(sec_to_time(t8.time_in_heart_rate_zone4/1000),':',-2),'N/A') as Z4,
    ifnull(substring_index(sec_to_time(t8.time_in_heart_rate_zone5/1000),':',-2),'N/A') as Z5
FROM
    training_event t1
        LEFT JOIN
    training_event_type t2 ON t1.training_course_id = t2.training_course_id AND t1.training_event_type_id = t2.training_event_type_id
        JOIN
    training_member t3 ON t1.training_course_id = t3.training_course_id
        LEFT JOIN
    gc_workout t4 ON t1.gc_workout_id = t4.gc_workout_id
		left join
	attendance_record t5 on t1.training_event_id = t5.training_event_id and t3.gcc_user_id = t5.gcc_user_id
		join
	gcc_user t6 on t3.gcc_user_id = t6.gcc_user_id
		left join
	 training_report t7 on t5.attendance_activity_id = t7.activity_id and t5.training_event_id = t7.training_event_id
		left join
	summarized_activity t8 on t7.activity_id = t8.activity_id

WHERE
    t3.training_course_id = ?
ORDER BY
	t6.fullname,t1.seq;