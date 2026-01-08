

-- S? se determine capacitatea maxim? a s?lii în care a jucat un juc?tor într-un anumit turneu.
--ex 8

--S? se creeze un subprogram stocat independent de tip func?ie care, pentru un juc?tor ?i un turneu date ca parametri, s? determine capacitatea maxim? a s?lii în care juc?torul respectiv a disputat meciuri în cadrul acelui turneu. Func?ia va utiliza într-o singur? comand? SQL trei tabele din baza de date ?i va trata excep?iile predefinite NO_DATA_FOUND ?i TOO_MANY_ROWS.
--(TOO_MANY_ROWS va fi tratat? teoretic, chiar dac? nu apare logic — este acceptat ?i des întâlnit la curs)

CREATE OR REPLACE FUNCTION capacitate_maxima_sala_jucator_turneu (
    p_jucator_id IN Jucator.jucator_id%TYPE,
    p_turneu_id  IN Turneu.turneu_id%TYPE
) RETURN NUMBER
IS
    v_capacitate Sala.capacitate%TYPE;
    v_dummy      NUMBER;
BEGIN
    -- Verificare existenta jucator
    SELECT 1 INTO v_dummy
    FROM Jucator
    WHERE jucator_id = p_jucator_id;

    -- Verificare existenta turneu
    SELECT 1 INTO v_dummy
    FROM Turneu
    WHERE turneu_id = p_turneu_id;

    -- Determinare capacitate maxima (3 tabele, un singur SQL)
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
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'Nu exista jucatorul, turneul sau jucatorul nu a disputat meciuri in turneul specificat.'
        );
        RETURN NULL;

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Exista mai multe valori posibile pentru capacitatea salii.'
        );
        RETURN NULL;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Eroare neasteptata: ' || SQLERRM
        );
        RETURN NULL;
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
--S? se creeze un subprogram stocat independent de tip procedur? care, pentru un juc?tor ?i un turneu date ca parametri, s? afi?eze detalii despre meciurile disputate de juc?tor în cadrul turneului, incluzând numele turneului, sala în care s-a jucat, arbitrul ?i adversarul. Procedura va utiliza într-o singur? comand? SQL cinci tabele din baza de date ?i va defini cel pu?in dou? excep?ii proprii pentru tratarea situa?iilor în care juc?torul nu exist? sau juc?torul nu a disputat niciun meci în turneul specificat. Procedura va fi apelat? astfel încât s? fie eviden?iate toate cazurile tratate.

CREATE OR REPLACE PROCEDURE detalii_meciuri_jucator_turneu (
    p_jucator_id IN Jucator.jucator_id%TYPE,
    p_turneu_id  IN Turneu.turneu_id%TYPE
) IS
    -- Excep?ii proprii
    e_jucator_inexistent EXCEPTION;
    e_fara_meciuri       EXCEPTION;

    v_exista NUMBER;
BEGIN
    -- Verificare existenta jucator
    SELECT COUNT(*)
    INTO v_exista
    FROM Jucator
    WHERE jucator_id = p_jucator_id;

    IF v_exista = 0 THEN
        RAISE e_jucator_inexistent;
    END IF;

    -- Cursor implicit (FOR) cu 5 tabele intr-un singur SELECT
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

