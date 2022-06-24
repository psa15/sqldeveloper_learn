drop table TBL_REPLY;
CREATE TABLE TBL_REPLY (
    RNO     NUMBER CONSTRAINT PK_REPLY PRIMARY KEY,
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

--댓글 목록
SELECT rn, rno, bno, reply, replyer, replydate, updatedate 
FROM (
    SELECT /*+ INDEX(tbl_reply PK_REPLY*/ ROWNUM rno, bno, reply, replyer, replydate, updatedate
    FROM tbl_reply
    WHERE ROWNUM <= #{pageNum} * #{amount}
)
WHERE rn > (#{pageNum}-1) * #{amount};

SELECT rn, rno, bno, reply, replyer, replydate, updatedate 
FROM (
    SELECT /*+ INDEX(tbl_reply PK_REPLY*/ ROWNUM rn, rno, bno, reply, replyer, replydate, updatedate
    FROM tbl_reply
    WHERE  bno = #{bno} AND ROWNUM <= #{pageNum} * #{amount}
)
WHERE rn > (#{pageNum}-1) * #{amount};

SELECT rn, rno, bno, reply, replyer, replydate, updatedate 
FROM (
    SELECT /*+ INDEX(tbl_reply PK_REPLY*/ ROWNUM rn, rno, bno, reply, replyer, replydate, updatedate
    FROM tbl_reply
    WHERE BNO = 100 AND ROWNUM <= 10
)
WHERE rn > 0;

--5120번 게시글 데이터 넣기
INSERT INTO tbl_reply(rno, bno, reply, replyer)
    select SEQ_REPLY.NEXTVAL, bno, reply, replyer from tbl_reply where bno=5120;
    -- bno에 이미 글번호가 있기 때문에(미리 하나 추가해둠) bno 그대로 사용 가능
    
commit;

--데이터 확인
 select rno, bno, reply, replyer from tbl_reply where bno=5120;