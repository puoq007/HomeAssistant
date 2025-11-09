TYPE=VIEW
query=select `sm`.`entity_id` AS `entity_id`,`s`.`state` AS `state`,`s`.`last_changed` AS `last_changed` from (`homeassistant`.`states` `s` join `homeassistant`.`states_meta` `sm` on(`s`.`metadata_id` = `sm`.`metadata_id`))
md5=18c929d11f11cfbb1ae1f965be0183a9
updatable=1
algorithm=0
definer_user=admin
definer_host=%
suid=2
with_check_option=0
timestamp=0001759960075832689
create-version=2
source=SELECT \n    sm.entity_id AS entity_id,\n    s.state AS state,\n    s.last_changed AS last_changed\nFROM states AS s\nJOIN states_meta AS sm \n    ON s.metadata_id = sm.metadata_id
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `sm`.`entity_id` AS `entity_id`,`s`.`state` AS `state`,`s`.`last_changed` AS `last_changed` from (`homeassistant`.`states` `s` join `homeassistant`.`states_meta` `sm` on(`s`.`metadata_id` = `sm`.`metadata_id`))
mariadb-version=110803
