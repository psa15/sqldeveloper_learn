CREATE TABLE TBL_ATTACH(
    UUID        VARCHAR2(100)   CONSTRAINT PK_ATTACH PRIMARY KEY,
    UPLOADPATH  VARCHAR2(200)   NOT NULL,
    FILENAME    VARCHAR2(100)   NOT NULL,
    FILETYPE    CHAR(1) DEFAULT '1',
    BNO         NUMBER,
    FOREIGN KEY(BNO) REFERENCES TBL_BOARD(BNO)
);

--uuid, uploadpath, filename, filetype, bno
select * from TBL_ATTACH where bno = 5125;
select * from TBL_board where bno = 5125;

delete from TBL_ATTACH where bno = 5125;
 commit;

select * from TBL_ATTACH where bno = 5126;