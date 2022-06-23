drop table TBL_REPLY;
CREATE TABLE TBL_REPLY (
    RNO     NUMBER PRIMARY KEY,
    BNO     NUMBER NOT NULL,    --게시판테이블의 글번호(FK)
    REPLY   VARCHAR2(500)   NOT NULL,   --댓글 내용
    REPLYER VARCHAR2(100)   NOT NULL,    --댓글 작성자
    REPLYDATE   DATE DEFAULT SYSDATE,
    UPDATEDATE   DATE DEFAULT SYSDATE,    
    CONSTRAINT FK_BOARD_REPLY_BNO FOREIGN KEY (BNO) REFERENCES TBL_BOARD(BNO) 
);

CREATE SEQUENCE SEQ_REPLY;

--rno, bno, reply, replyer, replydate, updatedate

INSERT INTO tbl_reply(rno, bno, reply, replyer) VALUES(SEQ_REPLY.NEXTVAL, #{bno}, #{reply}, #{replyer});