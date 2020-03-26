####################################################################################################################################################################################

#결제횟수
SELECT DATE(useDateTime) as 일, COUNT(oid) 결제횟수 FROM `tbl_order` WHERE useDateTime >= '2020-02-11 00:00:00' AND useDateTime < '2020-02-12 00:00:00'
group by  DATE(useDateTime)

#결제자수
SELECT DATE(useDateTime) as 일, COUNT(distinct memberRef) as 결제자수 FROM `tbl_order` WHERE useDateTime >= '2020-02-11 00:00:00' AND useDateTime < '2020-02-12 00:00:00'
group by  DATE(useDateTime)

#사용금액(결제+취소)
SELECT DATE(useDateTime) as 일, SUM(orderPrice) as 사용금액 FROM `tbl_order` WHERE useDateTime >= '2020-02-11 00:00:00' AND useDateTime < '2020-02-12 00:00:00'
group by  DATE(useDateTime)



####################################################################################################################################################################################
#취소금액  #프랜차이즈와 일반매장은 따로 구해야할듯
#useType = 6은 프랜차이즈

SELECT YEAR( useDateTime ) AS 사용년도, MONTH( useDateTime ) AS 사용월, SUM( accPoints ) AS 적립포인트, SUM( buyPoints ) AS 구매포인트, SUM( tampingPoints ) AS 탬핑포인트
FROM tbl_use
WHERE orderRef
IN (
SELECT oid
FROM tbl_order
WHERE state =5
)
# useType = 5 #일반매장
AND useDateTime >= "2017-01-01 00:00:00"
AND useDateTime < "2020-02-12 00:00:00"
GROUP BY YEAR( useDateTime ) , MONTH( useDateTime )




# 적립포인트 일일 발행현황 - 박미성
SELECT YEAR(creDateTime) AS 발행년도, DATE(creDateTime) AS 발행월, SUM(accPoints) AS 적립포인트
FROM tbl_pointsHistory
WHERE
    type = 1
    AND DATE(creDateTime) >= "2020-02-11 00:00:00"
    AND DATE(creDateTime) < "2020-02-12 00:00:00"
GROUP BY
    YEAR(creDateTime), DATE(creDateTime)


# 머지스토어 환불 
SELECT *
FROM tbl_pointsHistory
WHERE
shopRef = 1364
AND  creDateTime >= "2020-02-11 00:00:00"
AND  creDateTime < "2020-02-12 00:00:00"



# 만료 포인트 조사

SELECT *
FROM `tbl_pointsHistory`
WHERE `type` =3
AND totalPoints = 0
AND  creDateTime >= "2020-02-11 00:00:00"
AND  creDateTime < "2020-02-12 00:00:00"


#회수포인트 조사
SELECT *
FROM `tbl_pointsHistory`
WHERE `reason` LIKE '%회수%'
# WHERE 'reason' LIKE '%이동%'
AND totalPoints = 0
AND  creDateTime >= "2020-02-11 00:00:00"
AND  creDateTime < "2020-02-12 00:00:00"


#######################################################################################################################################################################

12.18 추가
일별로 브랜드별 결제자수와 결제횟수용!

# 일별 프렌차이즈 포인트량. (사용+취소) 
SELECT YEAR( useDateTime ) AS 사용년도, DATE( useDateTime ) AS 일별, consummerRef, shopName, SUM( orderPrice ) AS 사용금액
FROM tbl_order
WHERE consummerRef >0
    AND state IN (2,5)
    AND useDateTime >= "2020-02-11 00:00:00"
    AND useDateTime < "2020-02-12 00:00:00"
GROUP BY YEAR( useDateTime ) , DATE( useDateTime ) , consummerRef

#프랜차이즈 취소금액
SELECT YEAR( useDateTime ) AS 사용년도, MONTH(useDateTime) AS 월, consummerRef, shopName, SUM( orderPrice ) AS 취소금액
FROM tbl_order
WHERE consummerRef >0
    AND state IN (5)
   AND useDateTime >= "2020-02-01 00:00:00"
    AND useDateTime < "2020-02-12 00:00:00"
GROUP BY YEAR( useDateTime ), MONTH(useDateTime), consummerRef

#일반매장 일별 총 포인트량
SELECT YEAR( useDateTime ) AS 사용년도, DATE( useDateTime ) AS 일별, SUM( orderPrice ) AS 사용금액
FROM tbl_order
WHERE consummerRef = 0
    AND state IN (2,5)
    AND useDateTime >= "2020-02-01 00:00:00"
    AND useDateTime < "2020-02-12 00:00:00"
GROUP BY YEAR( useDateTime ) , DATE( useDateTime ) 

#일반매장 취소금액

SELECT MONTH( creDateTime ) AS 월, SUM( orderPrice ) AS 누적취소금액
FROM `tbl_payShop`
WHERE `consummerRef` =0
AND `settlementState` =5
AND `useState` =4
AND `creDateTime` >= '2020-02-01 00:00:00'
AND `creDateTime` < '2020-02-12 00:00:00'
GROUP BY YEAR(creDateTime), MONTH(creDateTime)

########################################################################################################
#신규가입자가 등록한 최초 프로모션 코드

SELECT oid, 
promotionRef, 
(
select name 
from tbl_promotion 
where pcode.promotionRef = oid) as 프로모션명,
code,
(
SELECT groupName
FROM tbl_pointCodeGroup
WHERE oid = pcode.groupRef
) AS 금액권명, 
points, 
registDateTime AS 등록일시, 

memberRef, 
memberName,  
(
SELECT creDateTime
FROM tbl_member
WHERE oid = pcode.memberRef
) AS 가입일시

from tbl_pointCode as pcode

where pcode.memberRef IN
(
SELECT oid
FROM `tbl_member`
WHERE `creDateTime` >= '2020-02-11 00:00:00'
AND `creDateTime` < '2020-02-12 00:00:00'
)
AND registDateTime >= '2020-02-11 00:00:00' 
AND registDateTime < '2020-02-12 00:00:00' 

GROUP BY memberRef  #group by 의 특성을 이용함





########################################################################################################
#프로모션 관리
SELECT oid, promotionRef,(select name from tbl_promotion where pcode.promotionRef = oid) as 프로모션명, code, (
SELECT groupName
FROM tbl_pointCodeGroup
WHERE oid = pcode.groupRef
) AS 금액권명, points, registDateTime AS 등록일시
FROM `tbl_pointCode` AS pcode
WHERE `promotionRef`
IN (222,223,240,241,244,248,251,256,257,265,266,268,269,272,275,276,277)
AND state =3
AND registDateTime >= '2019-10-01 00:00:00' 
AND registDateTime < '2020-02-03 00:00:00' 




#########################################################################################################
SELECT oid, name, id, phone, creDateTime AS 가입일, gender, visitDateTime AS 최종방문일, state, osType, points,
    (
        SELECT MIN(registDateTime)
        FROM tbl_pointCode
        WHERE
            memberRef = a.oid
    ) AS 최초적립일,
    (
        SELECT promotionRef
        FROM tbl_pointCode
        WHERE
            memberRef = a.oid
            AND registDateTime =(SELECT min(registDateTime) from tbl_pointCode  where memberRef = a.oid)
    ) AS 최초적립,
    (
        SELECT COUNT(oid)
        FROM tbl_pointCode
        WHERE
            memberRef = a.oid 
    ) AS 적립횟수
FROM tbl_member AS a
WHERE oid IN (101624)
######최초등록 파악!!!!!!!!!!!!########

SELECT  oid, name,creDateTime AS 가입일, (

SELECT MIN( DATE(registDateTime) )
FROM tbl_pointCode
WHERE memberRef = a.oid
) AS 최초적립일, (

SELECT MIN( promotionRef )
FROM tbl_pointCode
WHERE memberRef = a.oid
) AS 최초적립프로모션, (

SELECT MIN( groupRef )
FROM tbl_pointCode
WHERE memberRef = a.oid
) AS 최초적립코드그룹,
(
SELECT COUNT(oid)
FROM tbl_pointCode
WHERE
memberRef = a.oid 
AND registDateTime >= '2019-07-01 00:00:00' 
AND registDateTime < '2019-10-01 00:00:00' 
) AS 적립횟수

FROM tbl_member AS a

WHERE oid IN ( #바우쳐를 XX월부터 XX사이에 등록한 사람들
SELECT memberRef
FROM tbl_pointCode
WHERE 
state =3
AND registDateTime >= '2019-07-01 00:00:00' 
AND registDateTime < '2019-10-01 00:00:00' 
)
GROUP BY oid


################################################################################################################

#결제자 수
SELECT MONTH(useDateTime), memberRef, COUNT(oid) 
FROM `tbl_order`
WHERE state =2
AND useDateTime >= "2019-10-01 00:00:00"
AND useDateTime < "2019-11-01 00:00:00"
GROUP BY  memberRef



#8월 결제자 중 9월에 결제한 사람
SELECT memberRef, memberName, COUNT(oid), (
SELECT points
FROM tbl_member
WHERE a.memberRef = oid) AS 포인트잔량
FROM tbl_order a
WHERE 
state =2
AND companyPoints = 0
AND payPrice = 0
AND useDateTime >= "2019-07-01 00:00:00"
AND useDateTime < "2019-10-01 00:00:00"
GROUP BY  memberRef



SELECT
    code, groupRef, name, registDateTime AS 등록일, memberName, memberPhone,
    (SELECT
        creDateTime
    FROM tbl_member
        WHERE oid = a.memberRef
    ) AS 가입일
FROM tbl_pointCode AS a
WHERE
state = 3
     AND registDateTime >= "2019-09-01 00:00:00"
    AND registDateTime < "2019-10-01 00:00:00"


#7월과 9월 사이 최초 결제한 사람
SELECT memberRef, memberName,
(SELECT DATE(creDateTime)
FROM tbl_member
WHERE a.memberRef = oid
AND state = 1
AND creDateTime < "2019-07-01 00:00:00") AS 가입일

FROM tbl_order a

WHERE memberRef NOT IN ( #7월 전까지 결제 기록이 없었음
SELECT memberRef
FROM tbl_order
WHERE state =2
AND useDateTime < "2019-07-01 00:00:00"
)
AND state =2
AND useDateTime >= "2019-07-01 00:00:00"
AND useDateTime < "2019-10-01 00:00:00"
GROUP BY memberRef

##################################################################################
#주 단위로 카운트
SELECT DATE_FORMAT(DATE_SUB(`useDateTime`, INTERVAL (DAYOFWEEK(`useDateTime`)-2) DAY), '%Y/%m/%d') as start,
 DATE_FORMAT(DATE_SUB(`useDateTime`, INTERVAL (DAYOFWEEK(`useDateTime`)-8) DAY), '%Y/%m/%d') as end, 
 DATE_FORMAT(`useDateTime`, '%Y%U') AS `date`, COUNT(distinct memberRef) 
 FROM tbl_order
 WHERE state IN (2,5)
  AND useDateTime >= "2020-01-20 00:00:00"
  AND useDateTime < "2020-01-26 00:00:01" 
 GROUP BY date


