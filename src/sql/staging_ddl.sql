DROP TABLE IF EXISTS KOSYAK1998YANDEXRU__STAGING.group_log;

CREATE TABLE KOSYAK1998YANDEXRU__STAGING.group_log (
    group_id integer NOT NULL,
    user_id integer NOT NULL,
    user_id_from integer,
    event varchar(20),
    "datetime" timestamp(0),
    CONSTRAINT group_log_pkey PRIMARY KEY (user_id, "datetime") 
)
ORDER BY group_id, user_id
SEGMENTED BY hash(group_id) ALL NODES
PARTITION BY "datetime"::Date
GROUP BY CALENDAR_HIERARCHY_DAY(group_log."datetime"::Date, 3, 2);
