
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


-- sa fie in interval
CREATE OR REPLACE TRIGGER Trg_Meciuri
AFTER INSERT OR UPDATE ON meci
FOR EACH ROW
DECLARE
    v_turneu_start DATE;
    v_turneu_end DATE;
BEGIN
    SELECT data_inceput, data_final INTO v_turneu_start, v_turneu_end
    FROM turneu
    WHERE turneu_id = :NEW.turneu_id;
    
    IF :NEW.data >= v_turneu_start AND :NEW.data < v_turneu_end THEN
        RAISE_APPLICATION_ERROR(-20010, 'Eroare: Meciul trebuie sa fie intre data de inceput si final a turneului.');
    END IF;
END;
/

select * from turneu;
select* from meci;
INSERT INTO Meci
VALUES (
    100,1,2,1,1,1,
    TO_DATE('20-03-2025','DD-MM-YYYY')
);


UPDATE Meci
SET data = TO_DATE('12-03-2025','DD-MM-YYYY')
WHERE meci_id = 100;


INSERT INTO Meci
VALUES (
    101,
    3,
    4,
    1,
    1,
    1,
    TO_DATE('11-03-2025','DD-MM-YYYY')
);


INSERT ALL
    INTO Meci VALUES (
        102,
        1,
        3,
        1,
        1,
        1,
        TO_DATE('09-03-2025','DD-MM-YYYY')
    )
    INTO Meci VALUES (
        103,
        2,
        4,
        1,
        1,
        1,
        TO_DATE('12-03-2025','DD-MM-YYYY')
    )
SELECT * FROM dual;



-- sa nu se modifice prost datele la turneu
CREATE OR REPLACE TRIGGER TRG_TURNEU
AFTER INSERT OR UPDATE ON TURNEU
FOR EACH ROW
DECLARE
    ct NUMBER(10);
BEGIN
    select COUNT(*) INTO ct
    from meci
    where meci.turneu_id = :NEW.TURNEU_ID
    and ( :NEW.data_inceput > data or :new.data_final < data );
    
    IF ct > 0  THEN
        RAISE_APPLICATION_ERROR(-20011, 'Ai meciuri care ar iesi din intervalul turneului.');
    END IF;
END;
/


--  INSERT care MERGE
INSERT INTO Turneu
VALUES (
    10,
    'Turneu Test Valid',
    TO_DATE('01-08-2025','DD-MM-YYYY'),
    TO_DATE('05-08-2025','DD-MM-YYYY')
);


--  UPDATE care NU MERGE
UPDATE Turneu
SET data_inceput = TO_DATE('12-03-2025','DD-MM-YYYY'),
    data_final   = TO_DATE('13-03-2025','DD-MM-YYYY')
WHERE turneu_id = 1;





















