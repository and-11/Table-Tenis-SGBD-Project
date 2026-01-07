

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

--turneul trebuie sa aiba data valida
CREATE OR REPLACE TRIGGER trg_ValideazaDateTurneu
BEFORE INSERT OR UPDATE ON Turneu
FOR EACH ROW
BEGIN
    IF :NEW.data_final < :NEW.data_inceput THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare: Data de final nu poate fi inainte de data de inceput.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_contract_antrenor_perioada
BEFORE INSERT OR UPDATE ON Contract_antrenor
FOR EACH ROW
BEGIN
    IF :NEW.data_inceput >= :NEW.data_final THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Data de inceput a contractului trebuie sa fie anterioara datei de final.'
        );
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_EvitaAutoMeci
BEFORE INSERT OR UPDATE ON Meci
FOR EACH ROW
BEGIN
    IF :NEW.jucator_unu = :NEW.jucator_doi THEN
        RAISE_APPLICATION_ERROR(-20004, 'Eroare: Un jucator nu poate juca impotriva lui insusi.');
    END IF;
END;
/



CREATE OR REPLACE TRIGGER trg_limitare_sponsori_stmt
BEFORE INSERT OR UPDATE ON Contract_sponsorizare
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











