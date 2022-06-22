DROP SEQUENCE SEQ_BOARD;
CREATE SEQUENCE seq_board;

-- 테이블 데이터 날리기
DELETE FROM tbl_board;
--물리적 반영
COMMIT;

--데이터 확인
SELECT * FROM tbl_board; --없음

-- 페이징 쿼리를 위한 더미데이터(연습용 데이터) 작업
INSERT INTO tbl_board(bno, title, content, writer) 
    VALUES(seq_board.NEXTVAL, '테스트 게시물 데이터', '테스트 게시물 데이타', 'user01');
INSERT INTO tbl_board(bno, title, content, writer) 
    VALUES(seq_board.NEXTVAL, '테스트 게시물 데이터', '테스트 게시물 데이타', 'user02');
INSERT INTO tbl_board(bno, title, content, writer) 
    VALUES(seq_board.NEXTVAL, '테스트 게시물 데이터', '테스트 게시물 데이타', 'user03');
INSERT INTO tbl_board(bno, title, content, writer) 
    VALUES(seq_board.NEXTVAL, '테스트 게시물 데이터', '테스트 게시물 데이타', 'user04');
INSERT INTO tbl_board(bno, title, content, writer) 
    VALUES(seq_board.NEXTVAL, '테스트 게시물 데이터', '테스트 게시물 데이타', 'user05');
    
-- 여러개 데이터
--INSERT - SELECT 문 : SELECT실행한 결과를 INSERT문의 데이터로 쓰겠다
INSERT INTO tbl_board(bno, title, content, writer)
    SELECT seq_board.NEXTVAL, title, content, writer FROM tbl_board;
    
SELECT COUNT(*) FROM tbl_board; -- 5120개

/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!커밋 중요!!!!!!!!!!!!!!!!!!!!!*/
COMMIT; --commit을 해야 실제 데이터가 물리적으로 반영되어 프로젝트에서 확인 가능하다

/*
PAGE별 데이터를 10개씩 출력
1    2  3   4   5
*/
-- ROWNUM(사용 X) : 출력시 데이터행에 일련번호를 부여하는 기능, 조건식 사용시 중간범위를 가져올 수 없다
SELECT ROWNUM, bno, title, content FROM tbl_board WHERE ROWNUM < 11 ORDER BY bno DESC; 
--PAGE별 데이터 출력건 수 3개
SELECT ROWNUM, TITLE, CONTENT, WRITER FROM TBL_BOARD WHERE ROWNUM >=1 AND ROWNUM <=3; --얘는 가능
SELECT ROWNUM, TITLE, CONTENT, WRITER FROM TBL_BOARD WHERE ROWNUM >=4 AND ROWNUM <=6; --얘부터는 x
SELECT ROWNUM, TITLE, CONTENT, WRITER FROM TBL_BOARD WHERE ROWNUM >=7 AND ROWNUM <=9;

-- 페이징 쿼리 : ROWNUM과 인라인뷰를 이용
-- 인라인 뷰 : FROM절에서 사용하는 서브쿼리(SELECT문) 형태
SELECT ROWNUM rn, bno, title, content, writer, regdate FROM tbl_board; -- 인라인뷰로서 사용(이미 ROWNUM이 있기 때문에 물리적으로 존재)

-- 인라인뷰 적용한 SELECT문
SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT ROWNUM rn, bno, title, content, writer, regdate FROM tbl_board
)
WHERE rn >= 1 AND rn <= 3;

SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT ROWNUM rn, bno, title, content, writer, regdate FROM tbl_board
)
WHERE rn >= 4 AND rn <= 6;

SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT ROWNUM rn, bno, title, content, writer, regdate FROM tbl_board
)
WHERE rn >= 7 AND rn <= 9;

-- 페이징 쿼리(완성) : ROWNUM과 인라인뷰를 이용 + 인덱스 힌트 적용
/*
파라미터 : PAGENUM, AMOUNT
    PAGENUM : 페이지 번호    예) 1 2 3 4 5 중 선택했던 페이지 번호
    AMOUNT : 페이지마다 데이터 출력 건수
*/
--기본 뼈대(스프링에서 사용할)
SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT /*+ INDEX_DESC(tbl_board PK_BOARD) */ ROWNUM rn, bno, title, content, writer, regdate 
    FROM tbl_board
    WHERE ROWNUM <= #{pageNum} * #{amount}
)
WHERE rn > (#{pageNum}-1) * #{amount};
--적용
--PAGENUM = 1, AMOUNT = 10 (AMOUNT는 항상 고정)
SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT /*+ INDEX_DESC(tbl_board PK_BOARD) */ ROWNUM rn, bno, title, content, writer, regdate 
    FROM tbl_board
    WHERE ROWNUM <= (1 * 10)
)
WHERE rn > ((1-1) * 10); --RN이 10보다 작고 0보다 큰 값
--PAGENUM = 2, AMOUNT = 10 (AMOUNT는 항상 고정)
SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT /*+ INDEX_DESC(tbl_board PK_BOARD) */ ROWNUM rn, bno, title, content, writer, regdate 
    FROM tbl_board
    WHERE ROWNUM <= (2 * 10) --20건
)
WHERE rn > ((2-1) * 10); --10건(RN값이 10보다 큰 값 = 1페이지의 데이터 제외)
--PAGENUM = 3, AMOUNT = 10 (AMOUNT는 항상 고정)
SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT /*+ INDEX_DESC(tbl_board PK_BOARD) */ ROWNUM rn, bno, title, content, writer, regdate 
    FROM tbl_board
    WHERE ROWNUM <= (3 * 10) --30건
)
WHERE rn > ((3-1) * 10); --10건(RN값이 20보다 크거나 같은 것)
--이전페이지들에서 보여준 데이터는 제외하고 남은 데이터를 현재 페이지에서 보여준다.