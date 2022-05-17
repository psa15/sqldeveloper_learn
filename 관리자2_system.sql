--계정생성
CREATE USER docmall IDENTIFIED BY docmall;

--권한부여
GRANT CONNECT, RESOURCE, DBA TO docmall;
--docmall사용자가 작업시 발생되는 데이터를 저장하는 공간 생성 작업 : 테이블 스페이스 생성 작업
--보기메뉴 -> DBA 선택
/*
권한부여 명령어: GRANT
CONNECT : 접속(연결) 가능하게 해주는 권한
RESOURCE : 접속 후 안에서 사용하게 해주는 권한 - 자원사용(생성)
DBA : 오라클 내의 중요한 기능들을 할 수 있는 권한 (롯데월드의 높은 자리에 있는 직원) - 오라클 시스템 관리, 객체를 관리할 수 있는 권한
*/
