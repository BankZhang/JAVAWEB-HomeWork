### 本次SQL练习已全部完成
######################################## 练习一 ############################################
use employee_management;
# 1. 查询所有员工的姓名、邮箱和工作岗位。
    SELECT CONCAT(e.first_name,' ', e.last_name) '姓名', e.email '邮箱', e.job_title '工作岗位'
    FROM employees e;

# 2. 查询所有部门的名称和位置。
    SELECT d.dept_name '部门名称', d.location '位置'
    FROM departments d;

# 3. 查询工资超过70000的员工姓名和工资。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', e.salary '工资'
    FROM employees e
    WHERE e.salary > 70000;

# 4. 查询IT部门的所有员工。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', d.dept_name
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id AND d.dept_name = 'IT';

# 5. 查询入职日期在2020年之后的员工信息。
    SELECT *
    FROM employees e
    WHERE YEAR(e.hire_date) < 2020;

# 6. 计算每个部门的平均工资。
    SELECT d.dept_name, AVG(salary)
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id
    GROUP BY d.dept_id ;

# 7. 查询工资最高的前3名员工信息。
    SELECT *
    FROM employees e
    ORDER BY e.salary DESC
    LIMIT 3;

# 8. 查询每个部门员工数量。
    SELECT d.dept_name '部门', COUNT(e.emp_id)'员工数量'
    FROM departments d, employees e
    WHERE e.dept_id = d.dept_id
    GROUP BY d.dept_id;
# 9. 查询没有分配部门的员工。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', d.dept_name '部门'
    FROM employees e LEFT OUTER JOIN departments d on e.dept_id = d.dept_id
    WHERE d.dept_id IS NULL ;

# 10. 查询参与项目数量最多的员工。
    WITH ranked_employees AS (
        SELECT CONCAT(e.first_name, ' ', e.last_name) AS NAME, COUNT(p.project_id) AS project_num
        FROM employees e, employee_projects ep, projects p
        WHERE e.emp_id = ep.emp_id AND ep.project_id = p.project_id
        GROUP BY e.emp_id
        ORDER BY COUNT(p.project_id) DESC
    )
    SELECT re.NAME
    FROM ranked_employees re
    WHERE re.project_num = (
        SELECT re1.project_num
        FROM ranked_employees re1
        LIMIT 1
    );

# 11. 计算所有员工的工资总和。
    SELECT SUM(employees.salary)
    FROM employees;

# 12. 查询姓"Smith"的员工信息。
    SELECT *
    FROM employees
    WHERE employees.last_name = 'Smith';

# 13. 查询即将在半年内到期的项目。
-- 方法一
    SELECT *
    FROM projects
    WHERE TO_DAYS(end_date) - TO_DAYS(CURRENT_DATE) < 180 AND end_date > CURRENT_DATE;
    -- 方法二
    SELECT *
    FROM projects
    WHERE end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH );

# 14. 查询至少参与了两个项目的员工。
    SELECT CONCAT(e.first_name,' ',e.last_name)
    FROM employees e, employee_projects ep
    WHERE e.emp_id = ep.emp_id
    GROUP BY e.emp_id
    HAVING COUNT(project_id) >= 2;

# 15. 查询没有参与任何项目的员工。
    SELECT CONCAT(e.first_name,' ',e.last_name)
    FROM employees e
    WHERE e.emp_id NOT IN (
        SELECT emp_id
        FROM employee_projects
    );

# 16. 计算每个项目参与的员工数量。
    SELECT COUNT(ep.emp_id) '员工数量', p.project_name
    FROM employee_projects ep, projects p
    WHERE ep.project_id = p.project_id
    GROUP BY p.project_id;

# 17. 查询工资第二高的员工信息。
    -- LIMIT N,M 其中的N代表从第几行开始查询，M代表查出多少行
    SELECT CONCAT(e.first_name,' ',e.last_name), e.salary
    FROM employees e
    ORDER BY salary DESC
    LIMIT 1,1;

# 18. 查询每个部门工资最高的员工。
    WITH max_salary AS (
        SELECT e.dept_id AS dept_id, MAX(e.salary) AS maxsalary
        FROM employees e
        GROUP BY e.dept_id
    )
    SELECT CONCAT(e.first_name,' ',e.last_name), d.dept_name
    FROM employees e
             JOIN max_salary ms ON e.dept_id = ms.dept_id, departments d
    WHERE e.dept_id = d.dept_id AND e.salary = ms.maxsalary;

# 19. 计算每个部门的工资总和,并按照工资总和降序排列。
    SELECT SUM(e.salary) '工资总和', d.dept_name
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id
    GROUP BY d.dept_id
    ORDER BY SUM(e.salary) DESC;

# 20. 查询员工姓名、部门名称和工资。
    SELECT CONCAT(e.first_name,' ', e.last_name), dept_name, salary
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id;

# 21. 查询每个员工的上级主管(假设emp_id小的是上级)。
    WITH host_id AS (
                        SELECT MIN(e1.emp_id) AS min_id
                        FROM employees e1, departments d1
                        WHERE e1.dept_id = d1.dept_id
                        GROUP BY d1.dept_id
    )
    SELECT CONCAT(e.first_name,' ', e.last_name), dept_name
    FROM employees e, departments d, host_id
    WHERE e.dept_id = d.dept_id AND e.emp_id = host_id.min_id;

# 22. 查询所有员工的工作岗位,不要重复。
    SELECT DISTINCT d.dept_name
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id;


# 23. 查询平均工资最高的部门。
    WITH max_avg_salary AS (
        SELECT d.dept_id
        FROM employees e, departments d
        WHERE e.dept_id = d.dept_id
        GROUP BY d.dept_id
        ORDER BY avg(salary) DESC
        LIMIT 1
    )
    SELECT d.dept_name
    FROM departments d, max_avg_salary
    WHERE d.dept_id = max_avg_salary.dept_id;


# 24. 查询工资高于其所在部门平均工资的员工。
    SELECT CONCAT(first_name, ' ', last_name), dept_name
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id AND salary > (
        SELECT AVG(salary)
        FROM departments d1, employees e1
        WHERE d1.dept_id = e1.dept_id AND d1.dept_id = d.dept_id
    );

# 25. 查询每个部门工资前两名的员工。

    SELECT e.salary, e.first_name, e.last_name
    FROM employees e, departments d
    GROUP BY d.dept_name;

# 26. 查询跨部门的项目(参与员工来自不同部门)。
    SELECT p.project_name
    FROM employees e, employee_projects ep, projects p
    WHERE e.emp_id = ep.emp_id AND ep.project_id = p.project_id
    GROUP BY p.project_id
    HAVING COUNT(e.dept_id) >= 2;

# 27. 查询每个员工的工作年限,并按工作年限降序排序。
-- TIMESTAMPDIFF()用于计算两个日期或者时间值之间的差异
    WITH work_years AS (
        SELECT e.emp_id, TIMESTAMPDIFF(YEAR, e.hire_date,CURDATE()) AS work_days
        FROM employees e
    )

    SELECT CONCAT(first_name, ' ', last_name), work_years.work_days '工作年限'
    FROM employees e, work_years
    WHERE e.emp_id = work_years.emp_id;

# 28. 查询本月过生日的员工(假设hire_date是生日)。
    SELECT CONCAT(e.first_name, ' ', e.last_name), e.hire_date
    FROM employees e
    WHERE MONTH(hire_date) = MONTH(CURDATE());

# 29. 查询即将在90天内到期的项目和负责该项目的员工。
    SELECT p.project_name, CONCAT(e.first_name, ' ', e.last_name), end_date
    FROM employees e, projects p, employee_projects ep
    WHERE e.emp_id = ep.emp_id AND ep.project_id = p.project_id
    AND TIMESTAMPDIFF(DAY, CURDATE(), end_date) <= 90;

# 30. 计算每个项目的持续时间(天数)。
    SELECT p.project_name, TIMESTAMPDIFF(DAY, p.start_date, p.end_date) '持续天数'
    FROM projects p;

# 31. 查询没有进行中项目的部门。
    SELECT d.dept_name
    FROM departments d
    WHERE d.dept_id NOT IN (
        SELECT d1.dept_id
        FROM departments d1, employees e, employee_projects ep, projects p
        WHERE d1.dept_id = e.dept_id AND e.emp_id = ep.emp_id AND ep.project_id = p.project_id
        AND p.start_date < CURDATE() AND p.end_date > CURDATE()
    );

# 32. 查询员工数量最多的部门。
    SELECT d.dept_name
    FROM departments d, employees e
    WHERE e.dept_id = d.dept_id
    GROUP BY d.dept_id
    ORDER BY COUNT(emp_id) DESC
    LIMIT 1;

# 33. 查询参与项目最多的部门。
    SELECT d.dept_name, COUNT(p.project_id) '参与的项目数'
    FROM departments d, employees e, employee_projects ep, projects p
    WHERE d.dept_id = e.dept_id AND e.emp_id = ep.emp_id AND ep.project_id = p.project_id
    GROUP BY d.dept_id
    ORDER BY COUNT(p.project_id) DESC
    LIMIT 1;

# 34. 计算每个员工的薪资涨幅(假设每年涨5%)。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', ROUND((e.salary * POW(1.05, YEAR(CURDATE()) - YEAR(e.hire_date))) / e.salary, 1)  '涨幅'
    FROM employees e;
    -- ROUND(number, 1)截取一位小数

# 35. 查询入职时间最长的3名员工。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', (YEAR(CURDATE()) - YEAR(e.hire_date)) '任职期(年)'
    FROM employees e
    ORDER BY (YEAR(CURDATE()) - YEAR(e.hire_date)) DESC
    LIMIT 3;

# 36. 查询名字和姓氏相同的员工。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', e.first_name '名字', e.last_name '姓氏'
    FROM employees e
    WHERE e.first_name = e.last_name;

# 37. 查询每个部门薪资最低的员工。
    WITH ranked_employees AS (
         SELECT e.*, d.dept_name,
         RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary ASC ) AS salary_rank
         FROM employees e
         JOIN departments d ON e.dept_id = d.dept_id
    )
    SELECT *
    FROM ranked_employees
    WHERE salary_rank < 2;

# 38. 查询哪些部门的平均工资高于公司的平均工资。
    SELECT d.dept_name
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id
    GROUP BY d.dept_id
    HAVING AVG(e.salary) > (
        SELECT AVG(e.salary)
        FROM employees e
    );

# 39. 查询姓名包含"son"的员工信息。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名'
    FROM employees e
    WHERE e.first_name LIKE '%son%' OR e.last_name LIKE '%son%';

# 40. 查询所有员工的工资级别(可以自定义工资级别)。
    SELECT e.emp_id, CONCAT(e.first_name, ' ', e.last_name) '姓名', e.salary,
    CASE
        WHEN e.salary < 50000 THEN '低工资'
        WHEN e.salary BETWEEN 50000 AND 70000 THEN '中等工资'
        WHEN e.salary > 70000 THEN '高工资'
        ELSE '未定义'
    END AS salary_level
    FROM employees e;

# 41. 查询每个项目的完成进度(根据当前日期和项目的开始及结束日期)。
    SELECT p.project_name, IFNULL(CONCAT(DAY(CURDATE() - p.start_date) / (DAY(p.end_date - p.start_date)) * 100, '%'),'100%') '进度'
    FROM projects p;
    -- 利用concat(小数 * 100, '%') 将小数转换为百分数
    -- 利用IFNULL(有可能为空值的列, 一个确切的数)将已经完成的工程的 null 值转换为 100%


# 42. 查询每个经理(假设job_title包含'Manager'的都是经理)管理的员工数量。
    WITH ranked_employees AS (
        SELECT e.*, d.dept_name,
        RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary) AS salary_rank
        FROM employees e
        JOIN departments d ON e.dept_id = d.dept_id
    )
    SELECT CONCAT(re.first_name, ' ', re.last_name) '姓名', re.job_title, COUNT(re.emp_id)
    FROM ranked_employees re
    WHERE re.job_title LIKE '%Manager%';

# 43. 查询工作岗位名称里包含"Manager"但不在管理岗位(salary<70000)的员工。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', d.dept_name, e.salary
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id AND e.job_title LIKE '%Manager%'
                                AND d.dept_name != 'HR'
                                AND e.salary < 7000;

# 44. 计算每个部门的男女比例(假设以名字首字母A-M为女性,N-Z为男性)。
    SELECT d.dept_name, SUM(CASE WHEN e.first_name REGEXP '^[A-M]' THEN 1 ELSE 0 END) AS female_count,
            SUM(CASE WHEN e.first_name REGEXP '^[N-Z]' THEN 1 ELSE 0 END) AS male_count,
            CONCAT(ROUND(SUM(CASE WHEN e.first_name REGEXP '^[A-M]' THEN 1 ELSE 0 END) / COUNT(e.emp_id) * 100, 2), '%') AS female_percentage,
            CONCAT(ROUND(SUM(CASE WHEN e.first_name REGEXP '^[N-Z]' THEN 1 ELSE 0 END) / COUNT(e.emp_id) * 100, 2), '%') AS male_percentage
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id
    GROUP BY d.dept_id, d.dept_name
    ORDER BY d.dept_id;

# 45. 查询每个部门年龄最大和最小的员工(假设hire_date反应了年龄)。
    WITH age_max_ranked_employees AS (
        SELECT e.*, d.dept_name,
        RANK() OVER(PARTITION BY e.dept_id ORDER BY e.hire_date DESC ) AS salary_rank_max
        FROM employees e
        JOIN departments d ON e.dept_id = d.dept_id
    ),
    age_min_ranked_employees AS (
        SELECT e.*, d.dept_name,
        RANK() OVER(PARTITION BY e.dept_id ORDER BY e.hire_date ASC) AS salary_rank_min
        FROM employees e
        JOIN departments d ON e.dept_id = d.dept_id
    )
    SELECT amre1.dept_name, CONCAT(amre1.first_name, ' ', amre1.last_name) '年龄最大者姓名', amre1.hire_date
    FROM age_max_ranked_employees amre1, age_min_ranked_employees amre2
    WHERE amre1.salary_rank_max < 2
    UNION
    SELECT amre2.dept_name, CONCAT(amre2.first_name, ' ', amre2.last_name) '年龄最小者姓名', amre2.hire_date
    FROM age_min_ranked_employees amre2
    WHERE amre2.salary_rank_min < 2;

# 46. 查询连续3天都有员工入职的日期。
    SELECT e.hire_date - INTERVAL 2 DAY AS first_day,
           e.hire_date - INTERVAL 1 DAY AS second_day,
           e.hire_date AS third_day
    FROM employees e
    GROUP BY first_day, second_day, third_day
    HAVING COUNT(DISTINCT e.emp_id) = 3
    ORDER BY first_day;

# 47. 查询员工姓名和他参与的项目数量。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', COUNT(p.project_id) '参与的项目数量'
    FROM employees e, employee_projects ep, projects p
    WHERE e.emp_id = ep.emp_id AND ep.project_id = p.project_id
    GROUP BY e.emp_id;

# 48. 查询每个部门工资最高的3名员工。
    WITH ranked_employees AS (
         SELECT e.*, d.dept_name,
         RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary DESC) AS salary_rank
         FROM employees e
         JOIN departments d ON e.dept_id = d.dept_id
    )
    SELECT *
    FROM ranked_employees
    WHERE salary_rank <= 3;

# 49. 计算每个员工的工资与其所在部门平均工资的差值。
    SELECT CONCAT(e.first_name, ' ', e.last_name) '姓名', e.salary - AVG(e.salary)
    FROM employees e, departments d
    WHERE e.dept_id = d.dept_id
    GROUP BY d.dept_id;

# 50. 查询所有项目的信息,包括项目名称、负责人姓名(假设工资最高的为负责人)、开始日期和结束日期。
    WITH ranked_employees AS (
         SELECT e.*, p.*,
         RANK() OVER(PARTITION BY p.project_id ORDER BY e.salary DESC) AS salary_rank
         FROM employees e, employee_projects ep, projects p
         WHERE e.emp_id = ep.emp_id AND ep.project_id = p.project_id
    )
    SELECT re.project_name '项目名称', CONCAT(re.first_name, ' ', re.last_name) '负责人姓名', re.start_date, re.end_date
    FROM ranked_employees re
    WHERE re.salary_rank < 2;



######################################## 练习二 ############################################
USE student_management;
# 1. 查询所有学生的信息。
    SELECT * FROM student;

# 2. 查询所有课程的信息。
    SELECT * FROM course;

# 3. 查询所有学生的姓名、学号和班级。
    SELECT s.name, s.student_id, s.my_class
    FROM student s;

# 4. 查询所有教师的姓名和职称。
    SELECT t.name, t.title
    FROM teacher t;

# 5. 查询不同课程的平均分数。
    SELECT ce.course_name, AVG(se.score) '平均分数'
    FROM course ce, score se
    WHERE se.course_id = ce.course_id
    GROUP BY ce.course_id;

# 6. 查询每个学生的平均分数。
    SELECT st.name, AVG(se.score)
    FROM student st, score se
    WHERE st.student_id = se.student_id
    GROUP BY st.student_id;

# 7. 查询分数大于85分的学生学号和课程号。
    SELECT st.student_id, se.course_id, se.score
    FROM student st, score se
    WHERE st.student_id = se.student_id AND se.score > 85;

# 8. 查询每门课程的选课人数。
    SELECT ce.course_name, COUNT(st.student_id) '人数'
    FROM student st, course ce, score se
    WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    GROUP BY ce.course_id;

# 9. 查询选修了"高等数学"课程的学生姓名和分数。
    SELECT st.name, se.score, ce.course_name
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id = ce.course_id AND ce.course_name = '高等数学';

# 10. 查询没有选修"大学物理"课程的学生姓名。
    SELECT st.name
    FROM student st
    WHERE st.name NOT IN(
        SELECT st.name
        FROM student st, course ce, score se
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id AND ce.course_name = '大学物理');

# 11. 查询C001比C002课程成绩高的学生信息及课程分数。
    SELECT st.*, se.score, se.course_id
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    AND ce.course_id = 'C001' AND se.score >  (
                SELECT se1.score
                FROM score se1
                WHERE se1.course_id = 'C002' AND se1.student_id = st.student_id);

# 12. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
    SELECT ce.course_id, ce.course_name, COUNT(CASE WHEN se.score BETWEEN 85 AND 100 THEN 1 END) '[100-85]', COUNT(CASE WHEN se.score BETWEEN 85 AND 100 THEN 1 END) / COUNT(st.student_id) '占比',
            COUNT(CASE WHEN se.score BETWEEN 70 AND 85 THEN 1 END) '[85-70]', COUNT(CASE WHEN se.score BETWEEN 70 AND 85 THEN 1 END) / COUNT(st.student_id) '占比',
            COUNT(CASE WHEN se.score BETWEEN 60 AND 70 THEN 1 END) '[70-60]', COUNT(CASE WHEN se.score BETWEEN 60 AND 70 THEN 1 END) / COUNT(st.student_id) '占比',
            COUNT(CASE WHEN se.score BETWEEN 0 AND 60 THEN 1 END) '[60-0]',   COUNT(CASE WHEN se.score BETWEEN 0 AND 60 THEN 1 END) / COUNT(st.student_id) '占比'
    FROM course ce, score se, student st
    WHERE  se.course_id = ce.course_id
    GROUP BY ce.course_id;

# 13. 查询选择C002课程但没选择C004课程的成绩情况(不存在时显示为 null )。
    SELECT st.student_id, st.name, ce.course_id, ce.course_name, se.score
    FROM score se JOIN student st ON se.student_id = st.student_id JOIN course ce ON se.course_id = ce.course_id
    WHERE ce.course_id = 'C002' AND NOT EXISTS (
        SELECT 1
        FROM score se2
        JOIN course ce2 ON se2.course_id = ce2.course_id
        WHERE se2.student_id = se.student_id AND ce2.course_id = 'C004'
    );

# 14. 查询平均分数最高的学生姓名和平均分数。
    SELECT st.name, AVG(se.score)
    FROM student st, score se
    WHERE st.student_id = se.student_id
    GROUP BY st.student_id
    ORDER BY AVG(se.score) DESC
    LIMIT 1;

# 15. 查询总分最高的前三名学生的姓名和总分。
    SELECT st.name, SUM(se.score)
    FROM student st, score se
    WHERE st.student_id = se.student_id
    GROUP BY st.student_id
    ORDER BY SUM(se.score) DESC
    LIMIT 3;

# 16. 查询各科成绩最高分、最低分和平均分。要求如下：
# 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
# 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
# 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
    SELECT ce.course_id, ce.course_name, MAX(se.score) '最高分', MIN(se.score) '最低分', AVG(se.score) '平均分',
        COUNT(CASE WHEN se.score BETWEEN 60 AND 100 THEN 1 END) / COUNT(st.student_id) '及格率',
        COUNT(CASE WHEN se.score BETWEEN 70 AND 80 THEN 1 END) / COUNT(st.student_id) '中等率',
        COUNT(CASE WHEN se.score BETWEEN 80 AND 90 THEN 1 END) / COUNT(st.student_id) '优良率',
        COUNT(CASE WHEN se.score BETWEEN 90 AND 100 THEN 1 END) / COUNT(st.student_id) '优秀率',
        COUNT(se.student_id) '选课人数'
    FROM course ce, score se, student st
    WHERE  se.course_id = ce.course_id
    GROUP BY ce.course_id
    ORDER BY COUNT(se.student_id) DESC, ce.course_id ASC;

# 17. 查询男生和女生的人数。
    SELECT COUNT(CASE WHEN st.gender = '男' THEN 1 END ) '男生人数', COUNT(CASE WHEN st.gender = '女' THEN 1 END ) '女生人数'
    FROM student st;

# 18. 查询年龄最大的学生姓名。
    SELECT st.name
    FROM student st
    WHERE st.birth_date = (
        SELECT MIN(st1.birth_date)
        FROM student st1
    );

# 19. 查询年龄最小的教师姓名。
    SELECT t.name
    FROM teacher t
    WHERE t.birth_date = (
        SELECT MAX(t1.birth_date)
        FROM teacher t1
    );

# 20. 查询学过「张教授」授课的同学的信息。
    SELECT DISTINCT st.*
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id IN (
        SELECT ce.course_id
        FROM course ce, teacher t
        WHERE ce.teacher_id = t.teacher_id AND  t.name = '张教授'
    )
    ORDER BY st.student_id ASC;

# 21. 查询查询至少有一门课与学号为"2021001"的同学所学相同的同学的信息 。
    SELECT DISTINCT st.*
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND  se.course_id = ce.course_id
          AND ce.course_id IN(
              SELECT ce1.course_id
              FROM student st1, score se1, course ce1
              WHERE st1.student_id = se1.student_id AND  se1.course_id = ce1.course_id AND  st1.student_id = '2021001'
    ) AND st.student_id != '2021001';

# 22. 查询每门课程的平均分数，并按平均分数降序排列。
    SELECT ce.course_name, AVG(se.score)
    FROM score se, course ce
    WHERE se.course_id = ce.course_id
    GROUP BY ce.course_id
    ORDER BY AVG(se.score) DESC;

# 23. 查询学号为"2021001"的学生所有课程的分数。
    SELECT ce.course_name, se.score
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id = ce.course_id AND st.student_id = '2021001';

# 24. 查询所有学生的姓名、选修的课程名称和分数。
    SELECT st.student_id, ce.course_name, se.score
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND  se.course_id = ce.course_id;

# 25. 查询每个教师所教授课程的平均分数。
    SELECT t.name, ce.course_name, AVG(se.score) '平均分数'
    FROM teacher t, course ce, score se
    WHERE t.teacher_id = ce.teacher_id AND ce.course_id = se.course_id
    GROUP BY se.course_id;

# 26. 查询分数在80到90之间的学生姓名和课程名称。
    SELECT st.name, ce.course_name, se.score
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND ce.course_id = se.course_id AND se.score BETWEEN 80 AND 90;

# 27. 查询每个班级的平均分数。
    SELECT st.my_class, AVG(se.score)
    FROM student st, score se
    GROUP BY st.my_class;

# 28. 查询没学过"王讲师"老师讲授的任一门课程的学生姓名。
    SELECT st.name
    FROM student st
    WHERE st.student_id NOT IN(
        SELECT DISTINCT st.student_id
        FROM student st, score se, course ce
        WHERE st.student_id = se.student_id AND se.course_id IN (
            SELECT ce.course_id
            FROM course ce, teacher t
            WHERE ce.teacher_id = t.teacher_id AND  t.name = '王讲师'
        )
        ORDER BY st.student_id ASC
    );

# 29. 查询两门及其以上小于85分的同学的学号，姓名及其平均成绩 。
    SELECT st.student_id, AVG(se1.score)
    FROM student st, score se1, score se2
    WHERE st.student_id = se1.student_id AND se1.student_id = se2.student_id
          AND se1.score < 85 AND se2.score < 85
    GROUP BY st.student_id;

# 30. 查询所有学生的总分并按降序排列。
    SELECT st.name, SUM(se.score)
    FROM student st, score se
    WHERE st.student_id = se.student_id
    GROUP BY st.student_id
    ORDER BY SUM(se.score) DESC;

# 31. 查询平均分数超过85分的课程名称。
    SELECT ce.course_name, AVG(se.score)
    FROM score se, course ce
    WHERE ce.course_id = se.course_id
    GROUP BY se.course_id
    HAVING AVG(se.score) > 85;

# 32. 查询每个学生的平均成绩排名。
    SELECT st.name, AVG(se.score)
    FROM student st, score se
    WHERE st.student_id = se.student_id
    GROUP BY st.student_id
    ORDER BY AVG(se.score) DESC;

# 33. 查询每门课程分数最高的学生姓名和分数。
    WITH ranked_score AS (
        SELECT st.name, se.*,
        RANK() OVER(PARTITION BY ce.course_id ORDER BY se.score DESC) AS salary_rank
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    )
    SELECT rs.name, student_id, course_id, score
    FROM ranked_score rs
    WHERE rs.salary_rank < 2;

# 34. 查询选修了"高等数学"和"大学物理"的学生姓名。
    SELECT DISTINCT st.name, ce1.course_name, ce2.course_name
    FROM student st, score se1, score se2, course ce1, course ce2
    WHERE st.student_id = se1.student_id AND se1.course_id = ce1.course_id
          AND se1.student_id = se2.student_id AND se2.course_id = ce2.course_id
          AND ce1.course_name = '高等数学' AND ce2.course_name= '大学物理';

# 35. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩（没有选课则为空）。
    WITH ranked_score AS (
        SELECT st.name, se.*,
        AVG(se.score) OVER(PARTITION BY st.student_id ) AS average_grade
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    )
    SELECT rs.name, rs.score, rs.average_grade
    FROM ranked_score rs
    ORDER BY rs.average_grade DESC ;

# 36. 查询分数最高和最低的学生姓名及其分数。
    WITH ranked_max AS (
        SELECT st.name, se.score
        FROM student st, score se, course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
        ORDER BY se.score DESC
        LIMIT 1
    ), ranked_min AS(
        SELECT st.name, se.score
        FROM student st, score se, course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
        ORDER BY se.score ASC
        LIMIT 1
    )
    SELECT rm.name, rm.score
    FROM ranked_max rm
    UNION
    SELECT rn.name, rn.score
    FROM ranked_min rn;

# 37. 查询每个班级的最高分和最低分。
    WITH ranked_score_desc AS (
        SELECT st.name, se.*, st.my_class,
        RANK() OVER(PARTITION BY st.my_class ORDER BY se.score DESC) AS salary_rank
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    ),
        ranked_score_asc AS (
        SELECT st.name, se.*, st.my_class,
        RANK() OVER(PARTITION BY st.my_class ORDER BY se.score ASC) AS salary_rank
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    )
    SELECT rsd.my_class, rsd.score '最高分', rsc.score '最低分'
    FROM ranked_score_desc rsd, ranked_score_asc rsc
    WHERE rsd.salary_rank < 2 AND rsc.salary_rank < 2 AND rsd.my_class = rsc.my_class;

# 38. 查询每门课程的优秀率（优秀为90分）。
    SELECT se.course_id , CONCAT(COUNT(CASE WHEN se.score >= 90 THEN 1 END) / COUNT(se.student_id) * 100, '%') '优秀率'
    FROM course ce, score se
    WHERE ce.course_id = se.course_id
    GROUP BY se.course_id;

# 39. 查询平均分数超过班级平均分数的学生。
    WITH ranked_score AS (
        SELECT st.name, se.*,
        AVG(se.score) OVER(PARTITION BY st.my_class ) AS class_avg_grade,
        AVG(se.score) OVER (PARTITION BY st.student_id) AS personal_avg_grade
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    )
    SELECT  DISTINCT rs.name, rs.personal_avg_grade, rs.class_avg_grade
    FROM ranked_score rs
    WHERE rs.personal_avg_grade > rs.class_avg_grade;

# 40. 查询每个学生的分数及其与课程平均分的差值。
    WITH ranked_score AS (
        SELECT st.name, se.*,
        AVG(se.score) OVER(PARTITION BY se.course_id ) AS course_avg_grade
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    )
    SELECT DISTINCT rs.name, rs.score, rs.course_avg_grade '课程评级分', ABS(rs.score - rs.course_avg_grade) '差值'
    FROM ranked_score rs;

# 41. 查询至少有一门课程分数低于80分的学生姓名。
    SELECT DISTINCT st.name, se.score
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id = ce.course_id AND se.score < 80;

# 42. 查询所有课程分数都高于85分的学生姓名。
    SELECT st.name
    FROM student st
    WHERE st.name NOT IN(
        SELECT DISTINCT st.name
        FROM student st, score se, course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id AND se.score < 85
    );

# 43. 查询查询平均成绩大于等于90分的同学的学生编号和学生姓名和平均成绩。
    SELECT st.student_id, st.name, AVG(se.score)
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    GROUP BY st.student_id
    HAVING AVG(se.score) > 90;

# 44. 查询选修课程数量最少的学生姓名。
    SELECT st1.name, COUNT(ce1.course_id)
    FROM student st1, score se1, course ce1
    WHERE st1.student_id = se1.student_id AND se1.course_id = ce1.course_id
    GROUP BY st1.student_id
    HAVING COUNT(ce1.course_id) = (
        SELECT COUNT(ce.course_id)
        FROM student st, score se, course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
        GROUP BY st.student_id
        ORDER BY COUNT(ce.course_id) ASC
        LIMIT 1
    );

# 45. 查询每个班级的第2名学生（按平均分数排名）。
    WITH ranked_score_desc AS (
        SELECT st.name, se.*, st.my_class,
        RANK() OVER(PARTITION BY st.my_class ORDER BY AVG(se.score) DESC) AS salary_rank
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    )
    SELECT rsd.name
    FROM ranked_score_desc rsd
    WHERE rsd.salary_rank = 2;

# 46. 查询每门课程分数前三名的学生姓名和分数。
    WITH ranked_score_desc AS (
        SELECT st.name, se.*, st.my_class,
        RANK() OVER(PARTITION BY ce.course_id ORDER BY se.score DESC) AS salary_rank
        FROM student st, score se,course ce
        WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    )
    SELECT rsd.name, rsd.score, rsd.course_id
    FROM ranked_score_desc rsd
    WHERE rsd.salary_rank < 4;

# 47. 查询平均分数最高和最低的班级。
    WITH ranked_class_grade_desc AS (
        SELECT DISTINCT st.my_class, AVG(se.score) OVER(PARTITION BY st.my_class ) AS class_avg_grade
        FROM score se, student st
        WHERE st.student_id = se.student_id
        ORDER BY class_avg_grade DESC
        LIMIT 1
    ),
    ranked_class_grade_asc AS(
        SELECT DISTINCT st.my_class, AVG(se.score) OVER(PARTITION BY st.my_class ) AS class_avg_grade
        FROM score se, student st
        WHERE st.student_id = se.student_id
        ORDER BY class_avg_grade ASC
        LIMIT 1
    )
    SELECT rcgd.my_class '平均分最高班级', rcga.my_class '平均分最低班级'
    FROM ranked_class_grade_desc rcgd, ranked_class_grade_asc rcga;

# 48. 查询每个学生的总分和他所在班级的平均分数。
    SELECT DISTINCT st.name, st.my_class, SUM( DISTINCT se.score) AS personal_Sumgrade,
                    AVG(se.score) AS class_avg_grade
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id = se.course_id
    GROUP BY st.student_id, st.my_class;

# 49. 查询每个学生的最高分的课程名称, 学生名称，成绩。
    SELECT
        ce.course_name,
        st.name AS student_name,
        se.score AS highest_score
    FROM student st JOIN score se ON st.student_id = se.student_id
    JOIN course ce ON se.course_id = ce.course_id
    WHERE se.score = (
            SELECT MAX(score)
            FROM score
            WHERE student_id = st.student_id
    );

# 50. 查询每个班级的学生人数和平均年龄。
    SELECT COUNT( DISTINCT st.student_id) , AVG(YEAR(CURDATE()) - YEAR(st.birth_date)) '平均年龄'
    FROM student st, score se, course ce
    WHERE st.student_id = se.student_id AND se.course_id = ce.course_id
    GROUP BY st.my_class



