
-- Task 10
--Scopul acestui trigger este de a asigura respectarea unei reguli de business la nivelul bazei de date, conform c?reia un juc?tor nu poate avea mai mult de cinci contracte de sponsorizare active simultan, prin verificarea global? a num?rului de sponsori asocia?i fiec?rui juc?tor dup? executarea unei comenzi de tip INSERT sau UPDATE, prevenind astfel introducerea sau modificarea unor date care ar înc?lca aceast? regul? ?i men?inând integritatea ?i coeren?a informa?iilor din sistem.
CREATE OR REPLACE TRIGGER trg_limitare_sponsori
AFTER INSERT OR UPDATE ON Contract_sponsorizare
DECLARE
    v_nr NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_nr
    FROM (
        SELECT jucator_id
        FROM Contract_sponsorizare
        GROUP BY jucator_id
        HAVING COUNT(sponsor_id) > 5
    );

    IF v_nr > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Un jucator nu poate avea mai mult de 5 sponsori activi.'
        );
    END IF;
END;
/



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














--test all below

-- Trigers

CREATE OR REPLACE TRIGGER trg_ValideazaDateTurneu
BEFORE INSERT OR UPDATE ON Turneu
FOR EACH ROW
BEGIN
    IF :NEW.data_final < :NEW.data_inceput THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare: Data de final nu poate fi inainte de data de inceput.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_EvitaAutoMeci
BEFORE INSERT OR UPDATE ON Meci
FOR EACH ROW
BEGIN
    IF :NEW.jucator_unu = :NEW.jucator_doi THEN
        RAISE_APPLICATION_ERROR(-20002, 'Eroare: Un jucator nu poate juca impotriva lui insusi.');
    END IF;
END;
/


