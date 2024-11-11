/************************************************************
 * <DML> - SELECT / INSERT / UPDATE / DELETE
 ************************************************************/
--// 01. SELECT 
--// 테이블 전체 정보 조회 (*: 모든 칼럼명 선택)
SELECT *
	FROM PLAYER;

--// 원하는 컬럼만 조회
SELECT PLAYER_ID, PLAYER_NAME, TEAM_ID
	FROM PLAYER;

--// 원하는 ALIAS 사용 (컬럼명 바로 뒤에 사용하며 AS 생략가능함)
SELECT PLAYER_ID  선수ID, PLAYER_NAME  선수명, TEAM_ID  팀아이디
	FROM PLAYER;

--// 조회하는 컬럼기준으로 중복되는 행들 제거 (DISTINCT: 중복데이터를 1건으로 표시)
SELECT DISTINCT TEAM_ID
	FROM PLAYER;

--// 산술연산가능 (숫자나 날짜 데이터 자료형에 대해 가능하다) 
SELECT PLAYER_NAME AS 선수명, HEIGHT - WEIGHT AS "키-몸무게"
	FROM PLAYER;


--// 02. INSERT 
INSERT INTO PLAYER (PLAYER_ID, PLAYER_NAME, TEAM_ID, POSITION, HEIGHT, WEIGHT, BACK_NO) 
VALUES ('2024004', '박지성', 'K07', 'MF', 178, 73, 7);

--// 03. UPDATE 
--// 테이블의 모든 BACK_NO 값이 99로 변경됩니다!
UPDATE PLAYER SET BACK_NO = 99;

SELECT * FROM PLAYER;

--// 테이블의 모든 POSITION 값이 MF로 변경됩니다!
UPDATE PLAYER SET POSITION = 'MF'; --// 문자값인 경우 ‘ ’ 사용

--// 테이블의 PLAYER_ID 값이 2012108 인 행들의 BACK_NO 값이 99로 변경됩니다!
UPDATE PLAYER SET BACK_NO = 99 WHERE PLAYER_ID = 2012108;

--// 04. DELETE 
--// PLAYER 테이블의 모든 데이터가 삭제됩니다!
DELETE FROM PLAYER;

--// PLAYER 테이블에서 PLAYER_ID = 2012108 인행만 삭제됩니다!
DELETE FROM PLAYER WHERE PLAYER_ID = 2012108;


/************************************************************
 * <DDL> - CREATE / ALTER / DROP / TRUNCATE / (RENAME)
 ************************************************************/
--// 05. CREATE
CREATE TABLE PLAYER_OPPORTUNE
 ( PLAYER_ID     CHAR(7)     NOT NULL
 , PLAYER_NAME   VARCHAR(20) NOT NULL
 , TEAM_ID       CHAR(3)     NOT NULL
 , E_PLAYER_NAME VARCHAR(40)
 , NICKNAME      VARCHAR(30)
 , JOIN_YYYY     CHAR(4)
 , POSITION      VARCHAR(10)
 , BACK_NO       NUMBER
 , NATION        VARCHAR(20)
 , BIRTH_DATE    DATE 	     DEFAULT '2099-12-31'
 , SOLAR         CHAR(1)
 , HEIGHT        NUMBER
 , WEIGHT        NUMBER
 , CONSTRAINT PLAYER_PK_1 PRIMARY KEY (PLAYER_ID),
   CONSTRAINT PLAYER_FK_2 FOREIGN KEY (TEAM_ID) REFERENCES TEAM(TEAM_ID));

--// 생성하고 오라클이라면 DESC 테이블명, SQL SERVER 라면 ALT + F1 혹은 'sp_help 'dbo.테이블명' 으로 정보를 확인해보세요!

--// 06. ALTER
--// 컬럼추가
ALTER TABLE PLAYER
	ADD ADDRESS VARCHAR(80);

--// 컬럼삭제
ALTER TABLE PLAYER 
	DROP COLUMN ADDRESS; 

--// 컬럼수정
ALTER TABLE TEAM 
	MODIFY ORIG_YYYY VARCHAR(8) NOT NULL;
--ALTER TABLE TEAM ALTER COLUMN ORIG_YYYY VARCHAR(8) NOT NULL --SQL SERVER버전
--GO


--수정된 ORIG_YYYY 컬럼에 디폴트값도 추가해보자. (제약조건 추가 에서 배울내용)
ALTER TABLE TEAM 
	MODIFY ORIG_YYYY DEFAULT '20020129';
--ALTER TABLE TEAM ADD CONSTRAINT DF_ORIG_YYYYY DEFAULT '20020129' FOR ORIG_YYYY --SQL SERVER 버전
--GO 

--// 제약조건 추가
-- 제약조건중 FOREING KEY 외래키 제약조건을 추가해보자. TEAM테이블의 TEAM_ID 를 참고하도록.
ALTER TABLE PLAYER ADD CONSTRAINT PLAYER_FK FOREIGN KEY (TEAM_ID) REFERENCES TEAM(TEAM_ID);

-- 제약조건 추가하고 TEAM 테이블을 삭제해보자.  (삭제안됨)
DROP TABLE TEAM;

-- 제약조건 추가하고 TEAM 테이블의 데이터를 삭제해보자. (삭제안됨) 
DELETE TEAM WHERE TEAM_ID = 'K10';

--//추가설명
/*PLAYER 테이블의 TEAM_ID 컬럼이 TEAM 테이블의 TEAM_ID 컬럼을 참조하게 된다.
참조 무결성 옵션에 따라서 만약 TEAM 테이블이나 TEAM 테이블의 데이터를 삭제하려 할 경우
외부에서 참조되고 있기 때문에 삭제가 불가능하게 제약할 수 있다. 외부키를 설정함으로써
실수의 의한 테이블 삭제나 필요한 데이터의 의도하지 않은 삭제와 같은 불상사 방지효과*/

--// 제약조건 삭제 
ALTER TABLE PLAYER DROP CONSTRAINT PLAYER_FK;

--// 테이블과 컬럼의 이름변경
-- 컬럼명변경
ALTER TABLE PLAYER RENAME COLUMN PLAYER_ID TO TEMP_ID;
--sp_rename 'dbo.PLAYER.PLAYER_ID', 'TEMP_ID', 'COLUMN'--SQL SERVER
--GO

-- 테이블명변경
RENAME TEAM TO TEAM_BACKUP;
--sp_rename 'dbo.TEAM', 'TEAM_BACKUP'--SQL SERVER
--GO

/************************************************************
 * <TCL> - COMMIT, ROLLBACK
 ************************************************************/

--// 07. COMMIT, ROLLBACK 
/* 새로운 트랜잭션 시작 */

INSERT INTO PLAYER (PLAYER_ID, TEAM_ID, PLAYER_NAME, POSITION, HEIGHT, WEIGHT, BACK_NO)
VALUES ('1997035', 'K02', '이운재', 'GK', 182, 82, 1);

SAVEPOINT SVPT_A;

UPDATE PLAYER SET HEIGHT = 100

SAVEPOINT SVPT_B;

DELETE FROM PLAYER


--CASE1. SAEPOINT B 저장점까지 롤백을 수행하고 롤백 전후 데이터를 확인해본다
SELECT COUNT(*) AS CNT FROM PLAYER

ROLLBACK TO SVPOT_B;

SELECT COUNT(*) AS CNT FROM PLAYER

--CASE2. SAVEPOINT A 저장점까지 롤백을 수행하고 롤백 전후 데이터 확인해본다
SELECT COUNT(*) AS CNT FROM PLAYER WHERE WEIGHT = 100

ROLLBACK TO SVPT_A;

SELECT COUNT(*) AS CNT FROM PLAYER WHERE WEIGHT = 100

--CASE3. 트랜잭션 최초 시점까지 롤백을 수행하고 롤백 전후 데이터를 확인해본다
SELECT COUNT(*) AS CNT FROM PLAYER

ROLLBACK

SELECT COUNT(*) AS CNT FROM PLAYER


/************************************************************
 * <함수>
 ************************************************************/
--// 08. 문자형함수
--lower함수
SELECT LOWER('SQL') FROM DUAL;

--upper함수
SELECT UPPER('sql') FROM DUAL;

--concat 함수 (오라클 / SQL Server 둘 다 가능)
SELECT concat('PLAYER_NAME', ' 축구선수 ') AS 선수명 FROM player;

-- 오라클 
select PLAYER_NAME || ' 축구선수' AS 선수명 from player;

-- Sql server
--SELECT player_name + ' 축구선수' AS 선수명 
--	FROM player
--GO

--SELECT stadium_id
--    , DDD + ')' + TEL      AS TEL
--	, LEN(DDD + '-' + TEL) AS T_LEN 
--	FROM stadium;

--substr 함수
SELECT SUBSTR('SQLD합격',5,2) FROM DUAL;

--len 함수
--오라클 
SELECT LENGTH('Sql Expert') AS LEN FROM DUAL;

--Sql server
--SELECT Len('Sql Expert') AS LEN;

--LTRIM
SELECT LTRIM('AABBCCDDAA','A') FROM DUAL; 
SELECT LTRIM(' AABBCCDDAA ') FROM DUAL; 

--RTRIM
SELECT RTRIM('AABBCCDDAA','A') FROM DUAL; 
SELECT RTRIM(' AABBCCDDAA ') FROM DUAL; 

--TRIM
SELECT TRIM('A' FROM 'AABBCCDDAA') FROM DUAL; 
SELECT TRIM(' AABBCCDDAA ') FROM DUAL; 


--// 09. 숫자형 함수
-- 오라클
SELECT ENAME, ROUND(SAL / 12, 1)AS SQL_ROUND ,ROUND(SAL / 12) 
            , TRUNC(SAL/12,1) AS SAL_TRUNC  ,TRUNC(SAL/12)
	FROM EMP;


SELECT ABS(-10) FROM DUAL;
SELECT MOD(12,5) FROM DUAL;

-- Sql server
--SELECT ENAME, ROUND(SAL / 12) AS SAL_ROUND, CEIL (SAL/12) AS SAL_CEIL
--	FROM EMP 
--GO


--// 10. 날짜형 함수

-- 오늘날짜구하기
-- 오라클 
--SYSDATE
select sysdate from dual;

--EXTRACT
--오라클
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;

-- Sql server
--select getdate() as currentime;

-- 년, 월 , 일 추출 함수
-- 아래 4개의 예시는 모두 같은 기능을 하는 함수이다. 
-- 오라클  
SELECT ENAME						 AS 사원명
	  ,HIREDATE						 AS 입사일자
      ,EXTRACT( YEAR FROM HIREDATE)  AS 입사년도
      ,EXTRACT( MONTH FROM HIREDATE) AS 입사월
      ,EXTRACT( DAY FROM HIREDATE)	 AS 입사일
  FROM EMP;
 
-- SQL Server  
--SELECT ENAME						AS 사원명
--      ,HIREDATE						AS 입사일자
--      ,DATEPART( YEAR , HIREDATE)	AS 입사년도
--      ,DATEPART( MONTH , HIREDATE)  AS 입사월
--      ,DATEPART( DAY , HIREDATE)	AS 입사일
--  FROM EMP
--GO

-- 오라클  
SELECT ENAME	AS 사원명
	  ,HIREDATE AS 입사일자
	  ,TO_CHAR (HIREDATE, 'YYYY')
      ,TO_NUMBER( TO_CHAR (HIREDATE, 'YYYY')) AS 입사년도
      ,TO_NUMBER( TO_CHAR (HIREDATE, 'MM'))   AS 입사월
      ,TO_NUMBER( TO_CHAR (HIREDATE, 'DD'))   AS 입사일
  FROM EMP;

-- SQL Server 
--SELECT ENAME		   AS 사원명
--	  ,HIREDATE		   AS 입사일자
--	  ,YEAR(HIREDATE)  AS 입사년도 
--	  ,MONTH(HIREDATE) AS 입사월
--      ,DAY(HIREDATE)   AS 입사일
--  FROM EMP
--GO

--// 11. 변환형 함수
 
-- 원하는 날짜 형태로 변환하기 
-- 오라클 
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') 
	  ,TO_CHAR(SYSDATE, 'YYYY.MON, DAY')
  FROM DUAL;
 
-- SQL SERVER
--SELECT CONVERT(CHAR(10), GETDATE(),111) AS CURRENTDATE;

-- 오라클
SELECT TO_CHAR(123456789 / 1200, '$999,999,999.99') AS 환율반영달러
      ,TO_CHAR(123456789 , 'L999,999,999') AS 원화
  FROM DUAL;

-- TEAM테이블의 ZIP코드1과 코드2를 숫자로 변환한 후 두 항목을 더한 숫자를 출력한다. 
-- 오라클
SELECT TEAM_ID AS 팀ID
	  ,TO_NUMBER (ZIP_CODE1, '999') + TO_NUMBER(ZIP_CODE2, '999') AS 우편번호합
  FROM TEAM;

-- SQL SERVER
--SELECT TEAM_ID AS 팀ID
--	  ,CAST(ZIP_CODE1 AS INT) + CAST(ZIP_CODE2 AS INT) AS 우편번호합
--FROM TEAM
--GO

--SELECT ZIP_CODE1 
--	 , ZIP_CODE2 
--	 , ZIP_CODE1 + ' ' + ZIP_CODE2 AS '문자일때 결과'
--	 , CAST(ZIP_CODE1 AS INT) + CAST(ZIP_CODE2 AS INT) AS '숫자일때 결과' 
--FROM TEAM
--GO
 
--// 12. CASE문
 -- 부서 정보에서 부서 위치를 미국의 동부, 중부, 서부로 구분하라. 
SELECT  LOC
      ,(CASE LOC 
			WHEN 'NEW YORK' THEN 'EAST'
            WHEN 'BOSTON'   THEN 'EAST'
            WHEN 'CHICAGO'  THEN 'CENTER'
            WHEN 'DALLAS'   THEN 'CENTER'
         END) AS AREA
FROM DEPT;

-- 사원정보에서 급여가 3000이상이면 상등급으로, 1000 이상이면 중등급으로, 1000미만이면 하등급으로 분류하라.
SELECT ENAME
      ,(CASE
            WHEN SAL >= 3000 THEN 'HIGH'
            WHEN SAL >= 1000 THEN 'MID'
            ELSE 'LOW'
        END) AS SALARY_GRADE
FROM EMP;


-- 사원 정보에서 급여가 2000이상이면 보너스를 1000으로, 1000이상이면 500으로, 1000 미만이면 0으로 계산한다. 
SELECT ENAME
	 , SAL
     , (CASE
			WHEN SAL >= 2000 THEN 1000
			ELSE (CASE 
					  WHEN SAL >= 1000 THEN 500 
					  ELSE 0
                   END)
         END) AS BONUS
FROM EMP;



SELECT * FROM EMP WHERE COMM IS NOT NULL;


--// 13. NULL 관련함수

-- NVL 함수
SELECT NVL (NULL, 'NVL-OK') AS NVL_TEST FROM DUAL;
SELECT NVL ('Not-Null', 'NVL-OK') NVL_TEST FROM DUAL;

-- 선수 테이블에서 성남 일화천마(K08) 소속 선수의 이름과 포지션을 출력하는데
--, 포지션이 없는 경우는 '없음'으로 표시한다. 
SELECT PLAYER_NAME 	 			AS 선수명 
      ,POSITION		 			AS 포지션
      ,NVL (POSITION, '없음') 	AS NL포지션
  FROM PLAYER
 WHERE TEAM_ID = 'K08';

-- NULL 예제 
SELECT MGR
FROM EMP
WHERE ENAME = 'SCOTT';

SELECT MGR
FROM EMP
WHERE ENAME = 'KING';

SELECT NVL(MGR, 9999) AS MGR
FROM EMP
WHERE ENAME = 'KING';


-- 공집합 예제 
SELECT MGR
FROM EMP
WHERE ENAME = 'RYU';  -- 공집합


SELECT NVL(MGR, 9999) AS MGR
FROM EMP
WHERE ENAME = 'RYU';  -- 공집합인 경우는 NVL 혹은 ISNULL 사용해도 역시 공집합이다. NVL/ISNULL 은 공집합을 대상으로 하지 않는다.

-- 적절한 집계함수를 찾아서 NVL/NULL 함수 대신 적용. / 1개의 행이 선택됐다고 나오더라도 , 
-- 실 데이터는 null이다. 집계함수와 스칼라 서브쿼리의 경우는 인수의 결과 값이 공집합인 경우에도 NULL을 출력한다. 

SELECT MAX(MGR) AS MGR
FROM EMP
WHERE ENAME = 'RYU'; 

-- 집계함수를 인수로한 NVL/ISNULL 함수를 이용해서 공집합인 경우에도 빈칸이 아닌 9999로 출력하게 한다. 
--=> 공집합의 경우는 NVL함수를 사용해도 공집합이 출력되므로, 그룹함수와 NVL함수를 같이 사용해서 처리한다. 
SELECT NVL(MAX(MGR) , 9999) AS MGR
FROM EMP
WHERE ENAME = 'RYU';

-- COALESCE 
SELECT ENAME
	 , COMM
	 , SAL 
	 , COALESCE (COMM, SAL) AS COAL
FROM EMP;

-- NULLIF 
-- ISNULL 함수는 => ISNULL(MGR, 7698) 
-- 사원 테이블에서 MGR 와 7698이 같으면 NULL을 표시하고, 같지 않으면 MGR를 표시
SELECT ENAME, EMPNO, MGR, NULLIF(MGR, 7698) AS NUIF
FROM EMP;


/************************************************************
 * <WHERE 절>
 ************************************************************/
--//14. WHERE절 

SELECT * 
FROM EMP
WHERE SAL < 1000;


SELECT *
FROM EMP
WHERE JOB = 'SALESMAN'
  AND SAL > 1300;
 

SELECT ENAME, JOB, DEPTNO 
FROM EMP 
WHERE (JOB) IN ('MANAGER','CLERK'); 

SELECT ENAME, JOB, DEPTNO 
FROM EMP 
WHERE JOB= 'MANAGER'
   OR JOB='CLERK'; 
 
 
SELECT ENAME, JOB, DEPTNO 
FROM EMP 
WHERE (JOB, DEPTNO) IN (('MANAGER',20),('CLERK',30));


SELECT PLAYER_NAME, POSITION, BACK_NO, HEIGHT 
FROM PLAYER
WHERE PLAYER_NAME LIKE '장%';

--BETWEEN a AND b” -> “a 이상 b 이하”

SELECT PLAYER_NAME, POSITION, BACK_NO, HEIGHT 
FROM PLAYER
WHERE HEIGHT BETWEEN 170 AND 180;

--논리 연산자들이 여러 개가 같이 사용되었을 때의 처리 우선순위는 ( ), NOT, AND, OR의 순서대로 처리된다. 

SELECT PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM PLAYER
WHERE TEAM_ID = 'K02' AND POSITION <> 'MF' AND HEIGHT NOT BETWEEN 175 AND 185;
 
 
/************************************************************
 * <GROUP BY , HAVING 절>
 ************************************************************/

--// 15. GROUP BY, HAVING 절
SELECT POSITION				AS 포지션
	 , COUNT(*)				AS 인원수
	 , COUNT(HEIGHT)		AS 키대상
	 , MAX(HEIGHT)			AS 최대키
	 , MIN(HEIGHT)			AS 최소키
	 , ROUND(AVG(HEIGHT),2) AS 평균키 
FROM PLAYER 
GROUP BY POSITION;

SELECT  COUNT(*)			 AS 전체행수
	  , COUNT(HEIGHT)		 AS 키건수
	  , MAX(HEIGHT)			 AS 최대키 
	  , MIN(HEIGHT)			 AS 최소키
	  , ROUND(AVG(HEIGHT),2) AS 평균키
FROM PLAYER;

-- COUNT(*) 함수에 사용된 와일드카드(*) 는 전체 칼럼을 뜻한다.
-- COUNT(*) 는 전체 행의 개수 / COUNT(HEIGHT) 는 NULL 값 제외 

 
-- GROUP BY
SELECT POSITION AS 포지션, AVG(HEIGHT) AS 평균키
FROM PLAYER;

--> 결과 : 오류 

SELECT POSITION AS 포지션, AVG(HEIGHT) AS 평균키
FROM PLAYER
GROUP BY 포지션;

--> 결과 : 오류
--> ALIAS는 SELECT절에서 정의하고 ORDER BY 절에서는 재활용할 수 있지만, 
--  GROUP BY 절에서는 ALIAS명을 사용할 수 없다

-- HAVING 
SELECT POSITION AS 포지션, ROUND(AVG(HEIGHT),2) AS 평균키
FROM PLAYER
WHERE AVG(HEIGHT) >= 180
GROUP BY POSITION;

--> 결과 : 오류
--> WHERE절에서는 그룹함수는 허가되지 않는다. WHERE 절은 FROM 절에 정의된 집합의 개별 행에
--  WHERE절의 조건절이 먼저 적용되고, WHERE절의 조건에 맞는 행이 GROUP BY 절의 대상이 된다. 
--  그런 다음 결과 집합의 행에 HAVING 조건절이 적용된다. 결과적으로 HAVING 절의 조건을 만족
--  하는 내용만 출력된다. HAVING 절은 WHERE절과 비슷하지만 그룹을 나타내는 결과 집합행에 적용

SELECT POSITION AS 포지션, ROUND(AVG(HEIGHT),2) AS 평균키
FROM PLAYER
GROUP BY POSITION
HAVING AVG(HEIGHT) >= 180;


SELECT POSITION AS 포지션, ROUND(AVG(HEIGHT),2) AS 평균키
FROM PLAYER
GROUP BY POSITION
HAVING MAX(HEIGHT) >= 190;

--> SELECT 절에서 사용하지 않는 MAX 집계함수를 HAVING 절에서 조건절로 사용한 사례이다. 

/************************************************************
 * <ORDER BY 절>
 ************************************************************/
--//17. ORDER BY 절
SELECT PLAYER_NAME AS 선수명
			,POSITION AS 포지션
			,BACK_NO AS 백넘버
	FROM PLAYER
WHERE BACK_NO IS NOT NULL
ORDER BY 3 DESC, 2, 1;
 
 
 /************************************************************
 * <서브쿼리>
 ************************************************************/

--//18. 비연관서브쿼리, 연관서브쿼리
SELECT PLAYER_ID 
	FROM PLAYER
	WHERE TEAM_ID = (SELECT TEAM_ID 
					   FROM TEAM WHERE TEAM_ID= 'K06');

SELECT PLAYER_ID 
	FROM PLAYER A
	WHERE NOT EXISTS (SELECT * 
					    FROM TEAM B 
					    WHERE A.TEAM_ID = B.TEAM_ID);

 /************************************************************
 * <조인>
 ************************************************************/					   
--//19. 조인
CREATE TABLE CUSTOMER_1 
(고객ID VARCHAR(10), 고객명 VARCHAR(20));

CREATE TABLE ORDER_1 
(주문ID VARCHAR(10), 주문상품 VARCHAR(20), 고객ID VARCHAR(10));					   
					   
INSERT INTO CUSTOMER_1 VALUES('C01', 'SMITH');					   
INSERT INTO CUSTOMER_1 VALUES('C02', 'JONES');
INSERT INTO CUSTOMER_1 VALUES('C03', 'JAMES');
INSERT INTO CUSTOMER_1 VALUES('C04', 'BILL');
INSERT INTO CUSTOMER_1 VALUES('C05', 'WARD');

INSERT INTO ORDER_1 VALUES('Order01', '책상','C05');
INSERT INTO ORDER_1 VALUES('Order02', '의자','C02');
INSERT INTO ORDER_1 VALUES('Order03', '컴퓨터','C01');
INSERT INTO ORDER_1 VALUES('Order04', '마우스','C03');
INSERT INTO ORDER_1 VALUES('Order05', '키보드','C04');

SELECT A.고객ID, A.고객명 ,B.주문상품
FROM CUSTOMER_1 A INNER JOIN ORDER_1 B
ON A.고객ID = B.고객ID ORDER BY 1;


CREATE TABLE CUSTOMER_2
(고객ID VARCHAR(10), 고객명 VARCHAR(20));
CREATE TABLE ORDER_2
(주문ID VARCHAR(10), 주문상품 VARCHAR(20), 고객ID VARCHAR(10));					   
					   
INSERT INTO CUSTOMER_2 VALUES('C01', 'SMITH');					   
INSERT INTO CUSTOMER_2 VALUES('C02', 'JONES');
INSERT INTO CUSTOMER_2 VALUES('C03', 'JAMES');


INSERT INTO ORDER_2 VALUES('Order02', '책상','C01');
INSERT INTO ORDER_2 VALUES('Order03', '의자','C02');
INSERT INTO ORDER_2 VALUES('Order04', '컴퓨터','C04');


SELECT A.고객ID, B.고객ID AS 주문고객ID
FROM CUSTOMER_2 A FULL OUTER JOIN ORDER_2 B
ON A.고객ID = B.고객ID ORDER BY 1;



 







