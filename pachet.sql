--S? se creeze un pachet PL/SQL care s? gestioneze participarea juc?torilor la turnee, incluzând analiza meciurilor ?i a sponsoriz?rilor acestora. Pachetul va defini tipuri de date complexe pentru stocarea informa?iilor despre meciuri ?i sponsoriz?ri, precum ?i func?ii ?i proceduri care s? permit? verificarea existen?ei unui juc?tor, calcularea totalului sponsoriz?rilor ?i afi?area detaliilor complete ale particip?rii unui juc?tor într-un turneu. Pachetul va asigura un flux de ac?iuni integrate, specifice bazei de date definite.


CREATE OR REPLACE PACKAGE pkg_gestiune_turnee IS

    -- Tip de date complex: lista de sume
    TYPE t_sume_nt IS TABLE OF NUMBER;

    -- Tip de date complex: detalii meci
    TYPE t_meci_rec IS RECORD (
        adversar VARCHAR2(100),
        arbitru  VARCHAR2(100),
        sala     VARCHAR2(100)
    );

    TYPE t_meciuri_nt IS TABLE OF t_meci_rec;

    -- Functii
    FUNCTION exista_jucator (
        p_jucator_id IN Jucator.jucator_id%TYPE
    ) RETURN BOOLEAN;

    FUNCTION total_sponsorizari_jucator (
        p_jucator_id IN Jucator.jucator_id%TYPE
    ) RETURN NUMBER;

    -- Proceduri
    PROCEDURE afisare_sponsorizari (
        p_jucator_id IN Jucator.jucator_id%TYPE
    );

    PROCEDURE afisare_meciuri_turneu (
        p_jucator_id IN Jucator.jucator_id%TYPE,
        p_turneu_id  IN Turneu.turneu_id%TYPE
    );

END pkg_gestiune_turnee;
/





CREATE OR REPLACE PACKAGE BODY pkg_gestiune_turnee IS

    FUNCTION exista_jucator (
        p_jucator_id IN Jucator.jucator_id%TYPE
    ) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM Jucator
        WHERE jucator_id = p_jucator_id;

        RETURN v_count > 0;
    END exista_jucator;

    FUNCTION total_sponsorizari_jucator (
        p_jucator_id IN Jucator.jucator_id%TYPE
    ) RETURN NUMBER IS
        v_total NUMBER := 0;
        v_sume  t_sume_nt;
    BEGIN
        SELECT suma
        BULK COLLECT INTO v_sume
        FROM Contract_sponsorizare
        WHERE jucator_id = p_jucator_id;

        FOR i IN 1 .. v_sume.COUNT LOOP
            v_total := v_total + v_sume(i);
        END LOOP;

        RETURN v_total;
    END total_sponsorizari_jucator;

    PROCEDURE afisare_sponsorizari (
        p_jucator_id IN Jucator.jucator_id%TYPE
    ) IS
    BEGIN
        IF NOT exista_jucator(p_jucator_id) THEN
            DBMS_OUTPUT.PUT_LINE('Jucator inexistent.');
            RETURN;
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Total sponsorizari: ' ||
            total_sponsorizari_jucator(p_jucator_id)
        );
    END afisare_sponsorizari;

    PROCEDURE afisare_meciuri_turneu (
        p_jucator_id IN Jucator.jucator_id%TYPE,
        p_turneu_id  IN Turneu.turneu_id%TYPE
    ) IS
        v_meciuri t_meciuri_nt := t_meciuri_nt();
    BEGIN
        SELECT
            CASE
                WHEN m.jucator_unu = p_jucator_id
                THEN j2.nume || ' ' || j2.prenume
                ELSE j1.nume || ' ' || j1.prenume
            END,
            a.nume || ' ' || a.prenume,
            s.nume_sala
        BULK COLLECT INTO v_meciuri
        FROM Meci m
        JOIN Jucator j1 ON m.jucator_unu = j1.jucator_id
        JOIN Jucator j2 ON m.jucator_doi = j2.jucator_id
        JOIN Arbitru a ON m.arbitru_id = a.arbitru_id
        JOIN Sala s ON m.sala_id = s.sala_id
        WHERE m.turneu_id = p_turneu_id
          AND (m.jucator_unu = p_jucator_id
               OR m.jucator_doi = p_jucator_id);

        FOR i IN 1 .. v_meciuri.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Adversar: ' || v_meciuri(i).adversar ||
                ' | Arbitru: ' || v_meciuri(i).arbitru ||
                ' | Sala: ' || v_meciuri(i).sala
            );
        END LOOP;
    END afisare_meciuri_turneu;

END pkg_gestiune_turnee;
/


SET SERVEROUTPUT ON

BEGIN
    pkg_gestiune_turnee.afisare_sponsorizari(1);
    pkg_gestiune_turnee.afisare_meciuri_turneu(1, 5);
END;
/


