--select * FROM INFORMATION_SCHEMA.TABLES;


select try_cast(Date_format_clean as datetime),*  from (
SELECT 
Case 
WHEN TRY_CAST(date_of_birth_raw AS date) IS NOT NULL THEN CONVERT(varchar(10), TRY_CAST(date_of_birth_raw AS date), 101)
when date_of_birth_raw like '%____-__-__%' then  FORMAT(try_cast(date_of_birth_raw as datetime), 'MM/dd/yyyy hh:mm:ss tt')
when date_of_birth_raw like '%__/__/____%'  then SUBSTRING(date_of_birth_raw, 4, 2) + '/' + left(date_of_birth_raw,2)+ '/' + right(date_of_birth_raw,4) 
when date_of_birth_raw like '%____/__/__%' then SUBSTRING(date_of_birth_raw, 6, 2) + '/' + right(date_of_birth_raw,2)+ '/' + left(date_of_birth_raw,4) 
when date_of_birth_raw like '%__-__-____%' then SUBSTRING(date_of_birth_raw, 4, 2) + '/' + left(date_of_birth_raw,2)+ '/' + right(date_of_birth_raw,4) 
when date_of_birth_raw like '%__-__-____%' then SUBSTRING(date_of_birth_raw, 4, 2) + '/' + left(date_of_birth_raw,2)+ '/' + right(date_of_birth_raw,4) 
when date_of_birth_raw is null or date_of_birth_raw =' ' then  FORMAT(try_cast(date_of_birth_raw as datetime), 'MM/dd/yyyy hh:mm:ss tt')
when date_of_birth_raw like '%____?__?__%' then SUBSTRING(date_of_birth_raw, 6, 2) + '/' + SUBSTRING(date_of_birth_raw,9,2)+ '/' + left(date_of_birth_raw,4) 
when date_of_birth_raw like '%____.__.__%' then SUBSTRING(date_of_birth_raw, 6, 2) + '/' + SUBSTRING(date_of_birth_raw,9,2)+ '/' + left(date_of_birth_raw,4) 
else date_of_birth_raw 
end As Date_format_clean ,


* FROM dirty_lab.raw_customers) AS TABLE01