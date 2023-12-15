SELECT 
    u.username, 
    u.firstname, 
    u.lastname, 
    u.email, 
    STRING_AGG(DISTINCT g.name, ', ') AS groups
FROM 
    mdl_user u
JOIN 
    mdl_user_enrolments ue ON ue.userid = u.id
JOIN 
    mdl_enrol e ON e.id = ue.enrolid
JOIN 
    mdl_course c ON c.id = e.courseid
LEFT JOIN 
    mdl_groups_members gm ON gm.userid = u.id
LEFT JOIN 
    mdl_groups g ON g.id = gm.groupid AND g.courseid = c.id  -- Ensure group is in the same course
JOIN 
    mdl_role_assignments ra ON ra.userid = u.id
JOIN 
    mdl_context cx ON cx.id = ra.contextid AND cx.contextlevel = 50
JOIN 
    mdl_role r ON r.id = ra.roleid
WHERE 
    c.id = 1714  -- Replace 1714 with the specific course ID
    AND u.deleted = 0 
    AND ue.status = 0
    AND e.status = 0
    AND r.shortname = 'student'  -- Filter for students
    AND cx.instanceid = c.id
GROUP BY 
    u.username, 
    u.firstname, 
    u.lastname, 
    u.email;
