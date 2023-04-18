TRUNCATE TABLE KOSYAK1998YANDEXRU__DWH.s_auth_history;

INSERT INTO KOSYAK1998YANDEXRU__DWH.s_auth_history (
    hk_l_user_group_activity,
    user_id_from,
    event,
    event_dt,
    load_dt,
    load_src
)
SELECT 
    la.hk_l_user_group_activity,
    GL.user_id_from,
    GL.event,
    GL.event_ts as event_dt,
    now() as load_dt,
    's3' as load_src
FROM KOSYAK1998YANDEXRU__DWH.l_user_group_activity AS la
LEFT JOIN KOSYAK1998YANDEXRU__DWH.h_users AS hu ON la.hk_user_id = hu.hk_user_id
LEFT JOIN KOSYAK1998YANDEXRU__DWH.h_groups AS hg ON la.hk_group_id = hg.hk_group_id
LEFT JOIN KOSYAK1998YANDEXRU__STAGING.group_log AS GL 
    ON GL.user_id = hu.user_id AND GL.group_id = hg.group_id;
