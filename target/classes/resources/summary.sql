SELECT
    t6.fullname as 'Name',
    count(t5.training_event_id) as Attended,
    concat(truncate(count(t5.training_event_id)*100/(select count(training_event_id) from training_event where training_course_id = t3.training_course_id),2),'%') as AttendaceRate,
	ifnull(concat(truncate(avg((select reaching_rate from workout_step_summary where training_report_id = t7.training_report_id group by training_report_id))*100,2),'%'),'N/A') as Total,
    ifnull(concat(truncate(avg((select reaching_rate from workout_step_summary where training_report_id = t7.training_report_id and step_type = 1 group by training_report_id))*100,2),'%'),'N/A') as WarmUp,
    ifnull(concat(truncate(avg((select reaching_rate from workout_step_summary where training_report_id = t7.training_report_id and step_type = 2 group by training_report_id))*100,2),'%'),'N/A') as CoolDown,
    ifnull(concat(truncate(avg((select reaching_rate from workout_step_summary where training_report_id = t7.training_report_id and step_type = 3 group by training_report_id))*100,2),'%'),'N/A') as Run,
    ifnull(concat(truncate(avg((select reaching_rate from workout_step_summary where training_report_id = t7.training_report_id and step_type = 4 group by training_report_id))*100,2),'%'),'N/A') as Recovery,
	ifnull(concat(truncate(avg((select reaching_rate from workout_step_summary where training_report_id = t7.training_report_id and step_type = 5 group by training_report_id))*100,2),'%'),'N/A') as Rest,
	ifnull(concat(truncate(avg((select reaching_rate from workout_step_summary where training_report_id = t7.training_report_id and step_type = 7 group by training_report_id))*100,2),'%'),'N/A') as Other,
    ifnull(sec_to_time(sum(t8.time_in_heart_rate_zone1)/1000),'N/A') as Z1,
	ifnull(sec_to_time(sum(t8.time_in_heart_rate_zone2)/1000),'N/A') as Z2,
	ifnull(sec_to_time(sum(t8.time_in_heart_rate_zone3)/1000),'N/A') as Z3,
    ifnull(sec_to_time(sum(t8.time_in_heart_rate_zone4)/1000),'N/A') as Z4,
    ifnull(sec_to_time(sum(t8.time_in_heart_rate_zone5)/1000),'N/A') as Z5
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
    t3.training_course_id = ? and t3.state = 2
group by
	t6.gcc_user_id
ORDER BY
	t6.fullname,t1.seq;











