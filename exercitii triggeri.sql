--ex 10
--un jucator nu are voie mai multi de 5 sponsori
CREATE OR REPLACE TRIGGER trg_limitare_sponsori_stmt
AFTER INSERT OR UPDATE ON Contract_sponsorizare
DECLARE
    c_max_sponsori CONSTANT NUMBER := 5;
    v_count        NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM (
        SELECT jucator_id
        FROM Contract_sponsorizare
        GROUP BY jucator_id
        HAVING COUNT(*) > c_max_sponsori
    );

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'Eroare: Un jucator nu poate avea mai mult de '
            || c_max_sponsori
            || ' contracte de sponsorizare.'
        );
    END IF;
END;
/

select * from sponsor;
select * from jucator;
select * from contract_sponsorizare;

insert into jucator values( 100, 'Stefan', 'B', 'Macedonia');
-- 100 



 INSERT ALL
    INTO contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (100, 101, 15)
    INTO contract_sponsorizare(jucator_id, sponsor_id, suma) VALUES (100, 102, 15)
    INTO contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (100, 103, 15)
    INTO contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (100, 104, 15)
    INTO contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (100, 105, 15)
    INTO contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (100, 106, 15)
SELECT * FROM dual;



--ex 11
--Sponsorul trebuie sa dea o val pozitiva
CREATE OR REPLACE TRIGGER trg_ValideazaSumaSponsor
BEFORE INSERT OR UPDATE ON Contract_sponsorizare
FOR EACH ROW
BEGIN
    IF :NEW.suma <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Eroare: Suma sponsorizarii trebuie sa fie mai mare decat 0.');
    END IF;
END;
/

select * from contract_sponsorizare;

-- INSERT care MERGE
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma)
VALUES (2, 105, 500);


-- UPDATE care NU MERGE
UPDATE Contract_sponsorizare
SET suma = -100
WHERE jucator_id = 1
  AND sponsor_id = 101;


-- INSERT care NU MERGE
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma)
VALUES (2, 102, -1);


-- MULTI-INSERT care NU MERGE
INSERT ALL
    INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (3, 105, 200)
    INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (3, 104, -50)
SELECT * FROM dual;
select * from Contract_sponsorizare ;

--ex 12
-- tabela cu contractele de sponsorizare nu poate fi stearsa
CREATE OR REPLACE TRIGGER trg_drop_Contract_Sponsorizare
BEFORE DROP ON SCHEMA
BEGIN
    IF ORA_DICT_OBJ_TYPE = 'TABLE'
        AND ORA_DICT_OBJ_NAME = 'CONTRACT_SPONSORIZARE'
    THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'Eroare: Tabela Contract_Sponsorizare nu poate fi stearsa.'
        );
        
    END IF;
END;
/

drop table Contract_Sponsorizare;


drop trigger trg_drop_Contract_Sponsorizare;


