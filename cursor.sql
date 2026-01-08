--S? se creeze un subprogram stocat independent care, pentru fiecare turneu, s? afi?eze meciurile desf??urate în cadrul acestuia. Pentru fiecare meci se vor afi?a juc?torii participan?i ?i arbitrul. Subprogramul va utiliza dou? tipuri diferite de cursoare: un cursor explicit pentru parcurgerea turneelor ?i un cursor parametrizat, dependent de primul, pentru parcurgerea meciurilor fiec?rui turneu.
--ex 7
CREATE OR REPLACE PROCEDURE afisare_meciuri_turnee
IS
    -- Cursor explicit: toate turneele
    CURSOR c_turnee IS
        SELECT turneu_id, nume_turneu
        FROM Turneu;

    -- Cursor parametrizat: meciurile unui turneu
    CURSOR c_meciuri (p_turneu_id Turneu.turneu_id%TYPE) IS
        SELECT m.meci_id,
               j1.nume || ' ' || j1.prenume AS jucator_1,
               j2.nume || ' ' || j2.prenume AS jucator_2,
               a.nume  || ' ' || a.prenume  AS arbitru
        FROM Meci m
        JOIN Jucator j1 ON m.jucator_unu = j1.jucator_id
        JOIN Jucator j2 ON m.jucator_doi = j2.jucator_id
        JOIN Arbitru a  ON m.arbitru_id  = a.arbitru_id
        WHERE m.turneu_id = p_turneu_id;

BEGIN
    FOR t IN c_turnee LOOP
        DBMS_OUTPUT.PUT_LINE('Turneu: ' || t.nume_turneu);

        FOR m IN c_meciuri(t.turneu_id) LOOP
            DBMS_OUTPUT.PUT_LINE(
                '  Meci ' || m.meci_id || ': ' ||
                m.jucator_1 || ' vs ' || m.jucator_2 ||
                ' | Arbitru: ' || m.arbitru
            );
        END LOOP;
    END LOOP;
END;
/




SET SERVEROUTPUT ON

BEGIN
    afisare_meciuri_turnee;
END;
/
