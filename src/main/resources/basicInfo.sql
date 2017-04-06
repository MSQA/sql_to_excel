SELECT 
    t1.camp_id, 
    t1.title, 
    t2.name,
    (select count(training_event_id) from training_event where training_course_id = t1.training_course_id and start_time <= now()) as finished,
    count(t3.training_event_id) as total
FROM 
    training_course t1
        JOIN
    camp t2 ON t1.camp_id = t2.camp_id
		join
	training_event t3 on t1.training_course_id = t3.training_course_id
WHERE
    t1.training_course_id = ?;