--ex 10
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




