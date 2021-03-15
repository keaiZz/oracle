#实验一：SQL语句的执行计划分析与优化指导

## 实验目的

  分析SQL执行计划，执行SQL语句的优化指导。理解分析SQL语句的执行计划的重要作用。

## 实验内容

- 对Oracle12c中的HR人力资源管理系统中的表进行查询与分析。
- 首先运行和分析教材中的样例：本训练任务目的是查询两个部门('IT'和'Sales')的部门总人数和平均工资，以下两个查询的结果是一样的。但效率不相同。
- 设计自己的查询语句，并作相应的分析，查询语句不能太简单。

## 实验结果

- ### 教材样例：

  ![image-20210315154415756](E:\github\oracle\test1\image-20210315154415756.png)

分析：第一个是最优的，从两个语句的执行计划的统计信息可以看出第一个语句的递归调用次数以及读取的块数以及数据都少于第二个语句![image-20210315154627960](E:\github\oracle\test1\image-20210315154627960.png)

- ### 自己的查询语句(查询出每个部门薪水最高的人的姓名、薪水、部门编号)

  分析：根据部门编号分组查找薪水最高的，从表中查找对应编号输出结果

  ```sql
  select e.first_name,e.last_name,e.salary,e.department_id 
  from (select department_id,max(salary) m 
  from employees group by department_id) t,
  employees e where e.department_id=t.department_id and t.m=e.salary;
  ```

  ![image-20210315150304841](E:\github\oracle\test1\image-20210315150304841.png)

  ![image-20210315150328825](E:\github\oracle\test1\image-20210315150328825.png)

  ![image-20210315152314606](E:\github\oracle\test1\image-20210315152314606.png)







