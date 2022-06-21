CREATE TABLE TBL_BOARD (
    BNO     NUMBER   CONSTRAINT PK_BOARD PRIMARY KEY,   --글번호
    TITLE   VARCHAR2(100)   NOT NULL, --제목
    CONTENT VARCHAR2(4000)  NOT NULL, --내용
    WRITER  VARCHAR2(100)   NOT NULL, --작성자
    REGDATE DATE    DEFAULT SYSDATE   --등록일
);

CREATE SEQUENCE SEQ_BOARD;
--bno, title, content, writer, regdate