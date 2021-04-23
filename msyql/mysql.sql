REVERSE
(SUBSTR(REVERSE (g.tree_id), INSTR(REVERSE (g.tree_id), ',') + 1))
AS NAME REVERSE
(LEFT (REVERSE (g.tree_id), LOCATE(',', REVERSE (g.tree_id)) - 1))
AS NAME;

-- 查询重复数据
SELECT *
FROM `functions`
WHERE id NOT IN
      (SELECT MAX(id)
       FROM `functions`
       GROUP BY identify);

-- 删除重复数据
DELETE
FROM `functions`
WHERE id NOT IN (
    SELECT id
    FROM (
             SELECT id
             FROM `functions`
             WHERE id IN (SELECT id FROM `functions` GROUP BY identify HAVING COUNT(id) > 1)
         ) a
);
