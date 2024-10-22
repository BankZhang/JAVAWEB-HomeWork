# 作业要求
1. 完成teacher的CRUD练习，提供CRUD的代码。

2. 完成teacher表的批量插入练习，插入500个教师，每插入100条数据提交一次。
3. 完成可滚动的结果集练习，只查看结果集中倒数第2条数据。

# 已完成内容
1. CURD 练习

2. 批量插入数据
3. 可滚动的结果集练习
4. 可更新的结果集

注意:<br>
1. 在测试此作业时请先通过执行以下语句建立一个表:<br>
`CREATE TABLE 'teacher' (
  'id' int NOT NULL COMMENT 'id',
  'name' varchar(255) DEFAULT NULL COMMENT '姓名',
  'course' varchar(255) DEFAULT NULL COMMENT '课程',
  'birthday' date DEFAULT NULL COMMENT '生日',
  PRIMARY KEY ('id')
);`

2. 在执行 CURD 和 Batch_Insert 时保证表格为空，否则将因主键重复而无法插入
3. 在执行 Scrollable_Result 和 Updatable_Result 之前保证 teacher 表中有至少51条数据或者执行 Batch_Insert