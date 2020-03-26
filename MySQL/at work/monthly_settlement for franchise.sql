# 프랜차이즈 월 사용내역
# producerRef
#       pays = 1
#       smartcon = 2
SELECT oid, shopName, memberRef, memberName, barCode, orderPrice, state, useDateTime AS 사용일
FROM `tbl_order`
WHERE
    barcode IS NOT NULL
    AND consummerRef IN (SELECT oid
            FROM tbl_giftConsummer
            WHERE
                producerRef = 1
        )
    AND useDateTime >= "2020-01-01 00:00:00"
    AND useDateTime < "2020-02-01 00:00:00"