/*
검색조건 쿼리추가
*/
--1)검색타입(type) : 작성자, 2)검색어(keyword) : user01 
SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT /*+ INDEX_DESC(tbl_board PK_BOARD) */ ROWNUM rn, bno, title, content, writer, regdate 
    FROM tbl_board
    WHERE    writer LIKE '%user01%' AND  ROWNUM <= (1 * 10)
)
WHERE rn > ((1-1) * 10);

--뼈대
SELECT rn, bno, title, content, writer, regdate
FROM(
    SELECT /*+ INDEX_DESC(tbl_board PK_BOARD) */ ROWNUM rn, bno, title, content, writer, regdate 
    FROM tbl_board
    WHERE 검색타입 LIKE '%검색어%' AND  ROWNUM <= #{pageNum} * #{amount}
)
WHERE rn > (#{pageNum}-1) * #{amount};