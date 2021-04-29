-- 查询json数组
SELECT assetCategoryName
FROM (SELECT a.array -> '$[*].assetCategoryName' AS assetCategoryName
      FROM (SELECT service_request_attributes ->> '$.assetCategory' AS array
            FROM service_request
            WHERE service_request_code = 'S16091263610701544') a) b
WHERE assetCategoryName LIKE '%test%';


SELECT b ->> '$[*].assetCategoryName' AS d
FROM (SELECT service_request_attributes ->> '$.assetCategory' AS b
      FROM service_request
      WHERE service_request_code = 'S16091263610701544') AS a
WHERE b ->> '$[*].assetCategoryName' LIKE '%"%';

-- 查询一对多的数据，拼成一个json
SELECT u.id,
       u.NAME,
       u.username,
       u.pid,
       u.phone,
       u.file_url                 AS avatar,
       u.email,
       u.group_id                 AS mainGroup,
       (SELECT CONCAT('[', GROUP_CONCAT(
               CONCAT('{"id":', g1.id, ',', '"name":"', g1.NAME, '"}') SEPARATOR ','), ']')
        FROM groups g1
                 LEFT JOIN user_group ug1 ON g1.id = ug1.group_id
        WHERE ug1.user_id = u.id) AS `group`
FROM users u
         LEFT JOIN user_group ug ON u.id = ug.user_id
WHERE u.delete_time IS NULL
  AND u.work_status = 1
GROUP BY u.id
ORDER BY u.create_time DESC;

-- update json
UPDATE wxyx.service
SET template_information = json_set(template_information, '$.templateServiceInfo.title.show', 0),
    template_information = json_set(template_information, '$.templateServiceInfo.serious.show', 0)
WHERE template_code = 'AssetLoan';

-- delete json
UPDATE form_template
SET template_service_info = JSON_REMOVE(template_service_info, '$.title'),
    template_service_info = JSON_REMOVE(template_service_info, '$.assetFinanceList')
WHERE form_template_code = 'AssetMaintenance';

-- 新增json
UPDATE assets
SET asset_attributes = JSON_SET(asset_attributes, '$.end_time',
                                JSON_OBJECT("value", "", "text", ""))
