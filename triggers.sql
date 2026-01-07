

















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

CREATE OR REPLACE TRIGGER trg_ValideazaSumaSponsor
BEFORE INSERT OR UPDATE ON Contract_sponsorizare
FOR EACH ROW
BEGIN
    IF :NEW.suma <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Eroare: Suma sponsorizarii trebuie sa fie mai mare decat 0.');
    END IF;
END;
/
