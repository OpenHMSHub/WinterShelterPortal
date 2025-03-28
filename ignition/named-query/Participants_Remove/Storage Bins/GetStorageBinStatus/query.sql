SELECT
	*
FROM participant.vwStorageBinsLogDetails
WHERE
	(
		(:activityStatus = 0 AND expireOn > GETDATE() AND exitAction IS NULL) -- 0 = Active Bins only
			OR
		(:activityStatus = 1 AND (expireOn < GETDATE() OR exitAction IS NOT NULL)) -- 1 = Inactive / Expired Bins only
			OR
		(:activityStatus = 2) -- 2 = Active and Inactive Bins
	)
		AND
	(
		:searchFilter = ''
			OR
		 (
		 	:searchFilter != ''
		 		AND 
		 	(
		 		CONCAT(participantFirstName, ' ', participantMiddleName, ' ', participantLastName) LIKE :searchFilter
		 	 		OR
		 	 	CONCAT(col, bin) LIKE :searchFilter
		 	)
		 )
	)
		AND
	(
		:daysAgoFilter = 0
			OR
	 	startOn > CAST(CAST(DATEADD(day, -1*:daysAgoFilter, GETDATE()) AS DATE) AS DATETIME)
	)

ORDER BY
	startOn DESC