

--ex 8
CREATE OR REPLACE FUNCTION capacitate_maxima_sala_jucator_turneu (
    p_jucator_id IN Jucator.jucator_id%TYPE,
    p_turneu_id  IN Turneu.turneu_id%TYPE
) RETURN NUMBER
IS
    v_capacitate Sala.capacitate%TYPE;
    v_dummy      NUMBER(1);

    -- Exceptii proprii
    e_jucator_inexistent EXCEPTION;
    e_turneu_inexistent  EXCEPTION;
BEGIN
    -- Verificare existenta jucator
    BEGIN
        SELECT 1
        INTO v_dummy
        FROM Jucator
        WHERE jucator_id = p_jucator_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_jucator_inexistent;
    END;

    -- Verificare existenta turneu
    BEGIN
        SELECT 1
        INTO v_dummy
        FROM Turneu
        WHERE turneu_id = p_turneu_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_turneu_inexistent;
    END;

    SELECT MAX(s.capacitate)
    INTO v_capacitate
    FROM Meci m
    JOIN Sala s   ON m.sala_id   = s.sala_id
    JOIN Turneu t ON m.turneu_id = t.turneu_id
    WHERE t.turneu_id = p_turneu_id
      AND (m.jucator_unu = p_jucator_id
           OR m.jucator_doi = p_jucator_id);

    IF v_capacitate IS NULL THEN
        RAISE NO_DATA_FOUND;
    END IF;

    RETURN v_capacitate;

EXCEPTION
    WHEN e_jucator_inexistent THEN
        RAISE_APPLICATION_ERROR(
            -20012,
            'Jucatorul specificat nu exista.'
        );

    WHEN e_turneu_inexistent THEN
        RAISE_APPLICATION_ERROR(
            -20013,
            'Turneul specificat nu exista.'
        );

    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20014,
            'Jucatorul nu a disputat niciun meci in turneul specificat.'
        );

    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(
            -20015,
            'Exista mai multe valori posibile pentru capacitatea salii.'
        );

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20016,
            'Eroare neasteptata: ' || SQLERRM
        );
END;
/




SET SERVEROUTPUT ON

-- jucator si turneu valide
SELECT capacitate_maxima_sala_jucator_turneu(1, 1) FROM dual;

-- jucator inexistent
SELECT capacitate_maxima_sala_jucator_turneu(99, 1) FROM dual;

-- turneu inexistent
SELECT capacitate_maxima_sala_jucator_turneu(1, 99) FROM dual;






--ex 9

CREATE OR REPLACE PROCEDURE detalii_meciuri_jucator_turneu (
    p_jucator_id IN Jucator.jucator_id%TYPE,
    p_turneu_id  IN Turneu.turneu_id%TYPE
) IS
    -- Exceptii proprii
    e_jucator_inexistent EXCEPTION;
    e_fara_meciuri       EXCEPTION;

    v_exista NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_exista
    FROM Jucator
    WHERE jucator_id = p_jucator_id;

    IF v_exista = 0 THEN
        RAISE e_jucator_inexistent;
    END IF;

    v_exista := 0;

    FOR r IN (
        SELECT
            t.nume_turneu,
            s.nume_sala,
            a.nume || ' ' || a.prenume AS arbitru,
            CASE
                WHEN m.jucator_unu = p_jucator_id
                THEN j2.nume || ' ' || j2.prenume
                ELSE j1.nume || ' ' || j1.prenume
            END AS adversar
        FROM Meci m
        JOIN Turneu t ON m.turneu_id = t.turneu_id
        JOIN Sala s   ON m.sala_id   = s.sala_id
        JOIN Arbitru a ON m.arbitru_id = a.arbitru_id
        JOIN Jucator j1 ON m.jucator_unu = j1.jucator_id
        JOIN Jucator j2 ON m.jucator_doi = j2.jucator_id
        WHERE m.turneu_id = p_turneu_id
          AND (m.jucator_unu = p_jucator_id
               OR m.jucator_doi = p_jucator_id)
    ) LOOP
        v_exista := 1;

        DBMS_OUTPUT.PUT_LINE(
            'Turneu: ' || r.nume_turneu ||
            ' | Sala: ' || r.nume_sala ||
            ' | Arbitru: ' || r.arbitru ||
            ' | Adversar: ' || r.adversar
        );
    END LOOP;

    IF v_exista = 0 THEN
        RAISE e_fara_meciuri;
    END IF;

EXCEPTION
    WHEN e_jucator_inexistent THEN
        DBMS_OUTPUT.PUT_LINE(
            'Eroare: Jucatorul specificat nu exista.'
        );

    WHEN e_fara_meciuri THEN
        DBMS_OUTPUT.PUT_LINE(
            'Eroare: Jucatorul nu are niciun meci in turneul specificat.'
        );

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Eroare neasteptata: ' || SQLERRM
        );
END;
/


SET SERVEROUTPUT ON

BEGIN
    detalii_meciuri_jucator_turneu(1, 1);
END;
/

BEGIN
    detalii_meciuri_jucator_turneu(99, 1);
END;
/

BEGIN
    detalii_meciuri_jucator_turneu(5, 2);
END;
/

