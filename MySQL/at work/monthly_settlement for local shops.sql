# 전체 테이블 - 전체 점포 정산용
select
a.oid
,a.paymentRef
,a.shopRef
,a.shopName
,a.shopRate
,a.pgRate
,a.memberRate
,a.memberRef
,b.name as memberName
,a.companyRef
,(select companyName from tbl_company as com where a.companyRef = com.oid) as companyName
,b.departRef
,(select name from tbl_comDepart as depart where b.departRef = depart.oid) as departName
,a.menuName
,a.menuPrice
,a.useCount
,a.orderPrice
,a.companyPoints
,(a.payPrice + a.pointPrice) as usePoint
,a.payPrice
,a.pointPrice
,a.buyPoints
,a.tampingPoints
,a.accPoints
,round(a.companyPoints * (a.shopRate / 1000),0) as mergeCompCharge
,round((a.payPrice * (a.shopRate / 1000) + a.payPrice * (a.pgRate / 1000) + a.pointPrice * (a.shopRate / 1000 )),0) as mergeCharge
,round(a.payPrice * (a.pgRate / 1000),0) as pgCharge
,round(a.payPrice * (a.shopRate / 1000),0) as payPriceCharge
,round(a.pointPrice * (a.shopRate / 1000),0) as pointPriceCharge
,round(a.companyPoints * (a.shopRate / 1000) + (a.payPrice * (a.shopRate / 1000) + a.payPrice * (a.pgRate / 1000) + a.pointPrice * (a.shopRate / 1000 )),0) as totalMergeCharge
,round(a.companyPoints - (a.companyPoints * (a.shopRate / 1000)),0) as compSettlement
,round((a.payPrice - (a.payPrice * (a.shopRate / 1000)) - (a.payPrice * (a.pgRate / 1000))) + (a.pointPrice - (a.pointPrice * (a.shopRate / 1000))),0) as usePointSettlement
,round(a.payPrice - (a.payPrice * (a.shopRate / 1000)) - (a.payPrice * (a.pgRate / 1000)),0) as payPriceSettlement
,round(a.pointPrice - (a.pointPrice * (a.shopRate / 1000)),0) as pointPriceSettlement
,round(((a.payPrice * (a.shopRate / 1000) + a.payPrice * (a.pgRate / 1000) + a.pointPrice * (a.shopRate / 1000 )) -
        ((a.payPrice * (a.shopRate / 1000) + a.payPrice * (a.pgRate / 1000) + a.pointPrice * (a.shopRate / 1000 )) / 11)),0) as mergesupply
,round(((a.payPrice * (a.shopRate / 1000) + a.payPrice * (a.pgRate / 1000) + a.pointPrice * (a.shopRate / 1000 )) / 11),0) as mergeVAT
,round((a.companyPoints * (a.shopRate / 1000)) - ((a.companyPoints * (a.shopRate / 1000)/11)),0) as mergeCompsupply
,round((a.companyPoints * (a.shopRate / 1000)/11),0) as mergeCompVAT
,round((a.payPrice * (memberRate)/1000),0) as accumulatePoint
,a.useDateTime as useDateTime
,a.orderRef
,c.barcode
from tbl_use a
left outer join tbl_member b on a.memberRef = b.oid
left outer join tbl_order c on c.oid = a.orderRef
WHERE
        a.settlementState IN (2,3)
        AND useType IN (2, 3)
        AND a.useDateTime >= "2020-01-01 00:00:00"
        AND a.useDateTime < "2020-02-01 00:00:00"
ORDER BY a.useDateTime;

# 우미스시 - 6190
# 봉구스밥버거 - 1044, 1137, 6170

# crowdPay에서 직원 포인트, 식권 사용 내역 추출 - 기업회원 정산용
SELECT oid, crowdType
    ,memberRef
   ,(SELECT name
      FROM tbl_member
      WHERE oid = a.memberRef
   ) AS memberName,
   (SELECT phone
      FROM tbl_member
      WHERE oid = a.memberRef
   ) AS memberPhone,
   (
      SELECT departRef
      FROM tbl_member
      WHERE oid = a.memberRef
   ) as departRef,
   (SELECT name from tbl_comDepart where oid = departRef
   ) AS departName,
   companyRef,
   (SELECT companyName
      FROM tbl_company
      WHERE
         oid = a.companyRef
   ) AS companyName,
   shopRef, shopName,
   paymentRef, payShopRef,
   allocatePoint, remainPoints, remainTicketPoints,
   remainPoints + remainTicketPoints as sumPrice,
   returnPoints,
   approveDateTime as approveDateTime
FROM tbl_crowdPay AS a
WHERE
   paymentRef IN (
      SELECT oid
      FROM tbl_payment
         WHERE useState in (2,3)
         AND settlementState in (2,3)
         AND payDateTime >= "2020-01-01 00:00:00"
         AND payDateTime < "2020-02-01 00:00:00"
   )
   AND allocatePoint != 0
   AND approveState = 2
   AND useState in (2,3);



# 이중 사용 check용 사용 승인 금액 추출
SELECT payMenuRef, orderRef, COUNT(oid) AS useCount
FROM tbl_use
WHERE payMenuRef > 0
    AND orderRef > 0
    AND useDateTime >  "2019-08-01 00:00:00"
GROUP BY payMenuRef, orderRef
ORDER BY COUNT(oid) DESC





#기업 내역서
# 2020 02 10 
# 유슬기
SELECT oid,companyRef,(select companyName from tbl_company where a.companyRef = oid) as 기업명,
memberRef, memberName as 사원이름, 
senderRef, senderType,receiverRef, receiverType,
type, useType, category, 
reason, ticketCount, ticketUnitPrice,
returnPoint, point, remainPoint,
givenDateTime as 지급일, creDateTime as 이벤트생성일 
  FROM tbl_comPointHistory as a WHERE 1