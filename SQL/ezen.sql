--테이블 생성
CREATE TABLE student
(
  student_no NUMBER(4) NOT NULL,
  name VARCHAR2(20),
  age NUMBER(4),
  phone VARCHAR2(20),
  address VARCHAR2(100),
  memo VARCHAR2(200)
);
--시퀀스 생성
CREATE SEQUENCE student_seq;

-- 데이타 추가
INSERT INTO student
  (student_no, name, age, phone, address, memo)
VALUES
  (student_seq.nextval, '홍길동', 30, '010-1111-2222', '한양', '홍길동입니다.');
INSERT INTO student
  (student_no, name, age, phone, address, memo)
    VALUES
        (student_seq.nextval, '사임당', 40, '010-1111-4444', '천안', '사임당입니다.');
INSERT INTO student
  (student_no, name, age, phone, address, memo)
    VALUES
        (student_seq.nextval, '임꺽정', 35, '010-1111-5555', '대전', '임꺽정입니다.');
INSERT INTO student
    (student_no, name, age, phone, address, memo)
    VALUES
        (student_seq.nextval, '아이언맨', 45, '010-1111-6666', '뉴욕', '철사람입니다.');
INSERT INTO student
  (student_no, name, age, phone, address, memo)
    VALUES
        (student_seq.nextval, '잡스', 20, '010-1111-7777', '시카고', '잡스입니다.');
  
-- 데이터 검색
select * from student;


--테이블 생성
CREATE TABLE member (
    id      VARCHAR2(10)    PRIMARY KEY,
    name    VARCHAR2(30)    NOT NULL,
    age     NUMBER(3)       NOT NULL,
    address VARCHAR2(60)
);

--데이터 저장
INSERT INTO member VALUES ('dragon', '박문수', 40, '서울시');
INSERT INTO member VALUES ('sky', '김윤신', 30, '부산시');
INSERT INTO member VALUES ('blue', '이순신', 40, '인천시');


SELECT id, NAME, AGE, ADDRESS FROM member WHERE name LIKE '%신%';
