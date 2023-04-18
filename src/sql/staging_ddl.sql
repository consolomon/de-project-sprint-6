DROP TABLE IF EXISTS KOSYAK1998YANDEXRU__STAGING.group_log;

CREATE TABLE KOSYAK1998YANDEXRU__STAGING.group_log (
    group_id integer NOT NULL,
    user_id integer NOT NULL,
    user_id_from integer,
    event varchar(20),
    event_ts timestamp(0),
    CONSTRAINT group_log_pkey PRIMARY KEY (user_id, event_ts) 
)
ORDER BY group_id, user_id
SEGMENTED BY hash(group_id) ALL NODES
PARTITION BY event_ts::Date
GROUP BY CALENDAR_HIERARCHY_DAY(group_log.event_ts::Date, 3, 2);
