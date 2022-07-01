--게시판 글에 댓글 개수 추가
SELECT COUNT(*) FROM TBL_REPLY WHERE BNO = 5120;

update tbl_board set replycnt = 256 where bno = 5120;
commit;