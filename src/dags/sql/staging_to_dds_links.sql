TRUNCATE TABLE KOSYAK1998YANDEXRU__DWH.l_user_group_activity;

INSERT INTO KOSYAK1998YANDEXRU__DWH.l_user_group_activity (
    hk_l_user_group_activity,
    hk_user_id,
    hk_group_id,
    load_dt,
    load_src
)
SELECT
    hash(hu.hk_user_id, hg.hk_group_id),
    hu.hk_user_id,
    hg.hk_group_id,
    now() AS load_dt,
    's3' AS load_src
FROM KOSYAK1998YANDEXRU__STAGING.group_log AS GL
LEFT JOIN KOSYAK1998YANDEXRU__DWH.h_users AS hu ON GL.user_id = hu.user_id
LEFT JOIN KOSYAK1998YANDEXRU__DWH.h_groups AS hg ON GL.group_id = hg.group_id;

SELECT
    hash(hu.hk_user_id, hg.hk_group_id),
    hu.hk_user_id,
    hg.hk_group_id,
    now() AS load_dt,
    's3' AS load_src
FROM KOSYAK1998YANDEXRU__STAGING.group_log AS GL
LEFT JOIN KOSYAK1998YANDEXRU__DWH.h_users AS hu ON GL.user_id = hu.user_id
LEFT JOIN KOSYAK1998YANDEXRU__DWH.h_groups AS hg ON GL.group_id = hg.group_id;