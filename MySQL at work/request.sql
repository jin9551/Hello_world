#준호씨 연령별 파악
SELECT  year(b.birthday) as 연령별,
CASE WHEN b.gender =1
THEN '남자'
WHEN b.gender =2
THEN '여자'
ELSE '인증 안한 사람'
END AS '성별파악', 
COUNT(b.oid ) as 명수, 
max(a.consummerRef) as 가장많이간브랜드, a.shopName,
count(a.oid) as 결제횟수, round(avg(a.orderPrice), 0) as 평균결제금액 
FROM tbl_order a
left outer join tbl_member b on b.oid = a.memberRef
WHERE
b.verification = 1 
AND a.useDateTime >= "2020-02-01 00:00:00"
AND a.useDateTime < "2020-03-01 00:00:00"
group by year(b.birthday), b.gender;



# 김대용/프로모션 파악용
select a.memberRef,
(select name from tbl_member where a.memberRef = oid) as 이름, 
a.buyPoints, 
a.remainPoints, 
(select name from tbl_promotion where b.promotionRef = oid) as 프로모션명,
a.creDateTime as 이벤트생성일, 
b.registDateTime as 바우쳐등록시간, 
c.creDateTime as 가입일시
from tbl_pointsHistory a
left outer join tbl_pointCode b on a.memberRef = b.memberRef
left outer join tbl_member c on a.memberRef = c.oid
where
c.creDateTime >="2020-03-18 00:00:00"
and c.creDateTime <"2020-03-19 00:00:00" 
and b.promotionRef = 310
and b.state = 3
and a.type = 1
and a.kind = 3;






