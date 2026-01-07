


CREATE OR REPLACE TRIGGER trg_ValideazaSumaSponsor
BEFORE INSERT OR UPDATE ON Contract_sponsorizare
FOR EACH ROW
BEGIN
    IF :NEW.suma <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Eroare: Suma sponsorizarii trebuie sa fie mai mare decat 0.');
    END IF;
END;
/



select * from jucator;
select * from sponsor;
select * from Contract_sponsorizare;

INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 101, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 102, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 103, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 104, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 105, 5000);

select * from contract_sponsorizare;
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 106, 5000);



