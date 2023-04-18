-- H_USERS

DROP TABLE IF EXISTS KOSYAK1998YANDEXRU__DWH.h_users CASCADE;

CREATE TABLE KOSYAK1998YANDEXRU__DWH.h_users (
    hk_user_id bigint PRIMARY KEY,
    user_id integer,
    registration_dt timestamp(0),
    load_dt datetime,
    load_src varchar(20)
)
ORDER BY load_dt
SEGMENTED BY hk_user_id ALL NODES
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);

-- H_GROUPS

DROP TABLE IF EXISTS KOSYAK1998YANDEXRU__DWH.h_groups CASCADE;

CREATE TABLE KOSYAK1998YANDEXRU__DWH.h_groups (
    hk_group_id bigint PRIMARY KEY,
    group_id integer,
    registration_dt timestamp(6),
    load_dt datetime,
    load_src varchar(20)
)
ORDER BY load_dt
SEGMENTED BY hk_group_id ALL NODES
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);

-- L_USER_GROUP_ACTIVITY

DROP TABLE IF EXISTS KOSYAK1998YANDEXRU__DWH.l_user_group_activity;

CREATE TABLE KOSYAK1998YANDEXRU__DWH.l_user_group_activity (
    hk_l_user_group_activity bigint PRIMARY KEY,
    hk_user_id integer NOT NULL CONSTRAINT l_user_group_activity_user_fkey REFERENCES KOSYAK1998YANDEXRU__DWH.h_users (hk_user_id),
    hk_group_id integer NOT NULL CONSTRAINT l_user_group_activity_group_fkey REFERENCES KOSYAK1998YANDEXRU__DWH.h_groups (hk_group_id),
    load_dt datetime,
    load_src varchar(20)
)
ORDER BY load_dt
SEGMENTED BY hk_user_id ALL nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);

-- S_AUTH_HISTORY

DROP TABLE IF EXISTS KOSYAK1998YANDEXRU__DWH.s_auth_history;

CREATE TABLE KOSYAK1998YANDEXRU__DWH.s_auth_history (
    hk_l_user_group_activity bigint NOT NULL CONSTRAINT fk_s_auth_history_l_user_group_activity REFERENCES KOSYAK1998YANDEXRU__DWH.l_user_group_activity (hk_l_user_group_activity),
    user_id_from integer,
    event varchar(20),
    event_dt timestamp(0),
    load_dt datetime,
    load_src varchar(20)
)
ORDER BY load_dt
SEGMENTED BY hk_l_user_group_activity ALL NODES
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);

