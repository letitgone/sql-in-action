1.oracle表名不能加AS,  反例：select * from user as u

2.mysql的IF函数对应DECODE
IF(ccc.code is not null, CONCAT(g.name, '(', ccc.code, ')'), g.name) as groupName
DECODE( ccc.code, NULL, g.name || '(' || ccc.code || ')', g.name ) AS groupName

3.mysql的concat在oracle中可以使用 || 拼接

4.mybatis查询出的字段默认大写，可以指定为小写
pid as "pid"

5.msyql的GROUP_CONCAT
GROUP_CONCAT(u.id)
listagg(u.id, ',') WITHIN GROUP ( ORDER BY u.id )

6.mysql的find_in_set
oralce不能操作，需要使用存储过程
-----------------------------------------------------------------------------------------------------
CREATE OR REPLACE function find_in_set(
id in VARCHAR2,
ids in VARCHAR2)
return number
is
f_index number := 0;
l number;
temp VARCHAR2(255) := '';
t VARCHAR2(1);
/* lyl
*	 等效于mysql的FIND_IN_SET
*  用法：FIND_IN_SET('4','1,2,3,4,5') != 0
*  该函数会返回id在ids的位置，上例会返回4
*  如果没有在ids找到id，则返回0
   */
   BEGIN
   if nvl(id,null) is null or nvl(ids,null) is null then
   return 0;
   end if;
   l := LENGTH(ids);
   for i in 1 .. l loop
   t := SUBSTR(ids, i, 1);
   if t != ',' then
   temp := temp || t;
   else
   f_index := f_index + 1;
   if id = temp then
   return f_index;
   end if;
   temp := '';
   end if;
   end loop;
   f_index := f_index + 1;
   if id = temp then
   return f_index;
   end if;
   return 0;
   END;
-----------------------------------------------------------------------------------------------------

7.mysql的json查询
asset_attributes ->> "$.usegroup.value"
JSON_VALUE ( ASSET_ATTRIBUTES, '$.location.value' )

8.oracle group by后面的字段需要包含select后的字段
-----------------------------------------------------------------------------------------------------
SELECT f.id       as "id",
f.identify as "identify",
f.pid      as "pid",
f.is_show  as "is_show"
FROM role_user ru
LEFT JOIN role_function rf ON rf.role_id = ru.role_id
LEFT JOIN functions f ON f.id = rf.function_id
WHERE ru.user_id = #{userId}
AND f.permission_type IN (1, 2)
AND f.function_type = 1
GROUP BY f.id,
f.identify,
f.pid,
f.is_show
-----------------------------------------------------------------------------------------------------

9.oracle连接
database.driver=oracle.jdbc.OracleDriver
database.url=jdbc:oracle:thin:@//114.115.165.131:1521/cdb2
database.username=sys as sysdba
password=EMTC123456++

oracle不能像mysql指定默认连接的库
反例：jdbc:oracle:thin:@//114.115.165.131:1521/cdb2/test
oracle的库对应的是用户，所以直接使用test进行登录即可，不能拼接在url后面

