SELECT 
    c.id AS course_id,
    c.fullname AS course_name,
    c.idnumber,
    e.enrol AS enrolment_method,  -- Include the enrolment method
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 1 THEN 1 ELSE 0 END) AS January,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 2 THEN 1 ELSE 0 END) AS February,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 3 THEN 1 ELSE 0 END) AS March,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 4 THEN 1 ELSE 0 END) AS April,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 5 THEN 1 ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 6 THEN 1 ELSE 0 END) AS June,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 7 THEN 1 ELSE 0 END) AS July,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 8 THEN 1 ELSE 0 END) AS August,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 9 THEN 1 ELSE 0 END) AS September,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 10 THEN 1 ELSE 0 END) AS October,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 11 THEN 1 ELSE 0 END) AS November,
    SUM(CASE WHEN MONTH(FROM_UNIXTIME(ue.timecreated)) = 12 THEN 1 ELSE 0 END) AS December
FROM mdl_course c
JOIN mdl_enrol e ON e.courseid = c.id
JOIN mdl_user_enrolments ue ON ue.enrolid = e.id
JOIN mdl_user u ON u.id = ue.userid
JOIN mdl_role_assignments ra ON ra.userid = u.id
JOIN mdl_context ctx ON ctx.id = ra.contextid
    AND ctx.instanceid = c.id 
    AND ctx.contextlevel = 50
JOIN mdl_role r ON r.id = ra.roleid
WHERE u.deleted = 0
  AND ue.status = 0
  AND c.visible = 1
  AND r.shortname = 'student'
  AND YEAR(FROM_UNIXTIME(ue.timecreated)) = YEAR(CURDATE())  -- Filter for current year
GROUP BY c.id, e.enrol  -- Group by course and enrolment method
ORDER BY c.id ASC;
