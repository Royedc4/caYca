--------------------------------------------------------------------------------------------------------------
-- BillRow
--------------------------------------------------------------------------------------------------------------

CREATE TRIGGER `caYca`.`billRow_BEFORE_INSERT` BEFORE INSERT ON `billRow` FOR EACH ROW
BEGIN
IF (SELECT isRetailer FROM company where companyID=(SELECT buyer_companyID FROM bill WHERE seller_userID=NEW.seller_userID AND number=(SELECT bill_number FROM billRow WHERE serial=NEW.serial))) THEN
IF (SELECT isWholesaler FROM company where companyID=(SELECT buyer_companyID FROM bill WHERE seller_userID=NEW.seller_userID AND number=(SELECT bill_number FROM billRow WHERE serial=NEW.serial)))!=1 && (SELECT isImporter FROM company where companyID=(SELECT buyer_companyID FROM bill WHERE seller_userID=NEW.seller_userID AND number=(SELECT bill_number FROM billRow WHERE serial=NEW.serial)))!=1 THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'El Serial ya se le vendio a un Detal !!!!';
END IF;
END IF;
END;



CREATE TRIGGER `caYca`.`billRow_BEFORE_INSERT` BEFORE INSERT ON `billRow` FOR EACH ROW
BEGIN
IF (SELECT serial FROM billRow WHERE serial=NEW.serial)=NEW.serial && (SELECT userTypeID FROM user WHERE userID=(SELECT seller_userID from bill WHERE billNumber=NEW.billNumber) )='MAY'  THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'El Serial ya fue ingresado por un Mayorista!';
END IF;
END;


--------------------------------------------------------------------------------------------------------------
-- Bill
--------------------------------------------------------------------------------------------------------------
CREATE TRIGGER `caYca`.`Bill_BEFORE_INSERT` BEFORE INSERT ON `Bill` FOR EACH ROW
BEGIN
-- caYca Seller can only sells to Wholesaler.
IF (SELECT userTypeID FROM user WHERE userID=NEW.seller_userID)='CGG' || (SELECT userTypeID FROM user WHERE userID=NEW.seller_userID)='CA' THEN
    IF (SELECT isWholesaler FROM company WHERE companyID=NEW.buyer_companyID)!='1' THEN 
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'caYca solo le vende a Mayoristas!';
    END IF;
-- WholeSaler can only sells to Retailer.
ELSEIF (SELECT userTypeID FROM user WHERE userID=NEW.seller_userID)='MA' THEN
    IF (SELECT isRetailer FROM company WHERE companyID=NEW.buyer_companyID)!='1' THEN 
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Los Mayores solo le pueden vender a detales!';
    END IF;
-- Retailers can't sell on this system.
ELSEIF (SELECT userTypeID FROM user WHERE userID=NEW.seller_userID)='DV' THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Detales no pueden vender en este sistema!';
END IF;
-- Anyone cannot sell to himself.
IF (SELECT companyID FROM user where userID=NEW.seller_userID)=NEW.buyer_companyID THEN
    SIGNAL SQLSTATE '12345'
    SET MESSAGE_TEXT = 'No puede venderse a su misma empresa!';
END IF;
END;