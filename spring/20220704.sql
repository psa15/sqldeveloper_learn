uuid, uploadpath, filename, filetype, bno

select * from tbl_attach;
/* delete 진행 전 
b22fdb06-92a5-456f-8c09-eb286cec8c00	2022\07\04	ex01RootContextXml.txt	0	5127
64a1a521-5fc2-4059-8e64-d7ffbc4c851b	2022\07\01	ex00pom.txt	0	5126
717f1922-294c-45da-833d-bf5e2212f729	2022\07\01	geewon2.jpg	1	5126
d2cb78cd-41e3-420d-9dad-194f4055fc5d	2022\07\04	geewon.jpg	1	5127

진행 후
b22fdb06-92a5-456f-8c09-eb286cec8c00	2022/07/04	ex01RootContextXml.txt	1	5127
64a1a521-5fc2-4059-8e64-d7ffbc4c851b	2022\07\01	ex00pom.txt	0	5126
717f1922-294c-45da-833d-bf5e2212f729	2022\07\01	geewon2.jpg	1	5126
d2cb78cd-41e3-420d-9dad-194f4055fc5d	2022/07/04	geewon.jpg	1	5127
22ee8036-24d5-4cda-8476-f0db4c3b2317	2022\07\04	ex01ServletContext.txt	0	5127
*/