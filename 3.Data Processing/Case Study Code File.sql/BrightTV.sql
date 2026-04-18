SELECT 
    A.UserID,

    -- Gender
    CASE 
        WHEN A.Gender IS NULL OR TRIM(A.Gender) = '' OR LOWER(TRIM(A.Gender)) = 'none' 
        THEN 'Unknown' ELSE TRIM(A.Gender) 
    END AS Gender,

    -- Race
    CASE 
        WHEN A.Race IS NULL OR TRIM(A.Race) = '' OR LOWER(TRIM(A.Race)) = 'none' 
        THEN 'Unknown' ELSE TRIM(A.Race) 
    END AS Race,

    -- Age
    CASE 
        WHEN A.Age IS NULL OR CAST(A.Age AS STRING) = '0' 
        THEN 'Unknown' ELSE CAST(A.Age AS STRING) 
    END AS Age,

    -- Province
    CASE 
        WHEN A.Province IS NULL OR TRIM(A.Province) = '' OR LOWER(TRIM(A.Province)) = 'none' 
        THEN 'Unknown' ELSE TRIM(A.Province) 
    END AS Province,

    -- Channel
    CASE 
        WHEN B.Channel2 IS NULL OR TRIM(B.Channel2) = '' OR LOWER(TRIM(B.Channel2)) = 'none' 
        THEN 'Unknown' ELSE TRIM(B.Channel2) 
    END AS Channel,

    -- Record Date
    CASE 
        WHEN B.RecordDate2 IS NULL THEN 'Unknown'
        ELSE CAST(CAST(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', B.RecordDate2) AS DATE) AS STRING)
    END AS Record_Date,

    -- Record Time
    CASE 
        WHEN B.RecordDate2 IS NULL THEN 'Unknown'
        ELSE DATE_FORMAT(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', B.RecordDate2), 'HH:mm:ss')
    END AS Record_Time,

    -- Day of Week
    CASE 
        WHEN B.RecordDate2 IS NULL THEN 'Unknown'
        ELSE DATE_FORMAT(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', B.RecordDate2), 'EEEE')
    END AS Day_of_Week,

    -- Day Category
    CASE 
        WHEN B.RecordDate2 IS NULL THEN 'Unknown'
        WHEN DATE_FORMAT(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', B.RecordDate2), 'EEEE') 
             IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Category,

    -- Time Category (Peak)
    CASE 
        WHEN B.RecordDate2 IS NULL THEN 'Unknown'
        WHEN HOUR(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', B.RecordDate2)) BETWEEN 18 AND 22 THEN 'Evening Peak'
        WHEN HOUR(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', B.RecordDate2)) BETWEEN 6 AND 9   THEN 'Morning Peak'
        ELSE 'Off-Peak'
    END AS Time_Category,

    -- Duration Time
    CASE 
        WHEN B.`Duration 2` IS NULL THEN 'Unknown'
        ELSE DATE_FORMAT(B.`Duration 2`, 'HH:mm:ss')
    END AS Duration_Time,

    -- Duration Category
    CASE 
        WHEN B.`Duration 2` IS NULL THEN 'Unknown'
        WHEN MINUTE(B.`Duration 2`) < 5               THEN 'Very Short (< 5 min)'
        WHEN MINUTE(B.`Duration 2`) BETWEEN 5 AND 15  THEN 'Short (5-15 min)'
        WHEN MINUTE(B.`Duration 2`) BETWEEN 16 AND 30 THEN 'Medium (16-30 min)'
        WHEN MINUTE(B.`Duration 2`) BETWEEN 31 AND 60 THEN 'Long (31-60 min)'
        ELSE 'Extended (> 60 min)'
    END AS Duration_Category

FROM workspace.default.bright_tv_dataset_profile_users AS A
LEFT JOIN workspace.default.bright_tv_dataset_viewership AS B
ON A.UserID = B.UserID0;
