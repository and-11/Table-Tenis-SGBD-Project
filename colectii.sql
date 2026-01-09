--S? se creeze un subprogram stocat independent care, pentru un turneu dat ca parametru, s? determine juc?torii participan?i ?i s? analizeze sponsoriz?rile acestora. Pentru fiecare juc?tor se vor re?ine sponsorii s?i (�ntr-un VARRAY), valorile sponsoriz?rilor (�ntr-un tabel imbricat) ?i suma total? a sponsoriz?rilor (�ntr-un tabel indexat). Subprogramul va afi?a informa?iile ob?inute.
--ex 6

CREATE OR REPLACE PROCEDURE analiza_sponsorizari_turneu (
    p_turneu_id IN Turneu.turneu_id%TYPE
) IS
    -- Varray lista sponsorilor 
    TYPE t_sponsori_varray IS VARRAY(1000) OF Sponsor.nume%TYPE;
    v_sponsori t_sponsori_varray;

    -- Nested table valorile sponsorizarilor
    TYPE t_sume_nt IS TABLE OF Contract_sponsorizare.suma%TYPE;
    v_sume t_sume_nt;

    -- Index by table total sponsorizari
    TYPE t_total_sponsori IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_total t_total_sponsori;

BEGIN
    FOR j IN (
        SELECT DISTINCT j.jucator_id, j.nume, j.prenume
        FROM Jucator j
        JOIN Meci m ON j.jucator_id IN (m.jucator_unu, m.jucator_doi)
        WHERE m.turneu_id = p_turneu_id
    ) LOOP

        v_sponsori := t_sponsori_varray();
        v_sume     := t_sume_nt();
        v_total(j.jucator_id) := 0;

        FOR s IN (
            SELECT sp.nume AS nume_sponsor, cs.suma
            FROM Contract_sponsorizare cs
            JOIN Sponsor sp ON cs.sponsor_id = sp.sponsor_id
            WHERE cs.jucator_id = j.jucator_id
        ) LOOP
            IF v_sponsori.COUNT < 5 THEN
                v_sponsori.EXTEND;
                v_sponsori(v_sponsori.COUNT) := s.nume_sponsor;
            END IF;

            v_sume.EXTEND;
            v_sume(v_sume.COUNT) := s.suma;

            v_total(j.jucator_id) :=
                v_total(j.jucator_id) + s.suma;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(
            'Jucator: ' || j.nume || ' ' || j.prenume
        );
        DBMS_OUTPUT.PUT_LINE(
            '  Total sponsorizari: ' || v_total(j.jucator_id)
        );
    END LOOP;
END;
/



SET SERVEROUTPUT ON

BEGIN
    analiza_sponsorizari_turneu(1);
END;
/

BEGIN
    analiza_sponsorizari_turneu(3);
END;
/

BEGIN
    analiza_sponsorizari_turneu(5);
END;
/