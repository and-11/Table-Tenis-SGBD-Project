-- Creeare Tabele

-- 1. Tabelul Turneu 
CREATE TABLE Turneu (
    turneu_id INT PRIMARY KEY,
    nume_turneu VARCHAR(100),
    locatie VARCHAR(100),
    data_inceput DATE,
    data_final DATE
);

-- 2. Tabelul Arbitru
CREATE TABLE Arbitru (
    arbitru_id INT PRIMARY KEY,
    nume VARCHAR(50),
    prenume VARCHAR(50),
    nationalitate VARCHAR(50)
);

-- 3. Tabelul Jucator
CREATE TABLE Jucator (
    jucator_id INT PRIMARY KEY,
    nume VARCHAR(50),
    prenume VARCHAR(50),
    nationalitate VARCHAR(50)
);

-- 4. Tabelul Paleta 
CREATE TABLE Paleta (
    paleta_id INT PRIMARY KEY,
    jucator_id INT,
    tip_lemn VARCHAR(50),
    tip_cauciuc_negru VARCHAR(50),
    tip_cauciuc_rosu VARCHAR(50),
    FOREIGN KEY (jucator_id) REFERENCES Jucator(jucator_id)
);

-- 5. Tabelul Meci 
CREATE TABLE Meci (
    meci_id INT PRIMARY KEY,
    jucator_unu INT,
    jucator_doi INT,
    turneu_id INT,
    arbitru_id INT,
    locatie VARCHAR(100),
    data DATE,
    FOREIGN KEY (jucator_unu) REFERENCES Jucator(jucator_id),
    FOREIGN KEY (jucator_doi) REFERENCES Jucator(jucator_id),
    FOREIGN KEY (turneu_id) REFERENCES Turneu(turneu_id),
    FOREIGN KEY (arbitru_id) REFERENCES Arbitru(arbitru_id)
);

-- 6. Tabelul Antrenor
CREATE TABLE Antrenor (
    antrenor_id INT PRIMARY KEY,
    nume VARCHAR(50),
    prenume VARCHAR(50),
    nationalitate VARCHAR(50)
);

-- 7. Tabelul Sponsor
CREATE TABLE Sponsor (
    sponsor_id INT PRIMARY KEY,
    nume VARCHAR(100)
);

-- 8. Tabelul Contract_antrenor
CREATE TABLE Contract_antrenor (
    antrenor_id INT,
    jucator_id INT,
    data_inceput DATE,
    data_final DATE,
    PRIMARY KEY (antrenor_id, jucator_id),
    FOREIGN KEY (antrenor_id) REFERENCES Antrenor(antrenor_id),
    FOREIGN KEY (jucator_id) REFERENCES Jucator(jucator_id)
);

-- 9. Tabelul Contract_sponsorizare
CREATE TABLE Contract_sponsorizare (
    jucator_id INT,
    sponsor_id INT,
    suma DECIMAL(10, 2),
    PRIMARY KEY (jucator_id, sponsor_id),
    FOREIGN KEY (jucator_id) REFERENCES Jucator(jucator_id),
    FOREIGN KEY (sponsor_id) REFERENCES Sponsor(sponsor_id)
);

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




CREATE OR REPLACE TRIGGER trg_LimitaSponsoriComanda
AFTER INSERT OR UPDATE ON Contract_sponsorizare
DECLARE
    v_id_problema INT;
    v_numar_contracte INT;
BEGIN
    -- C?ut?m dac? exist? vreun juc?tor care, dup? aceast? comand?, are > 5 contracte
    BEGIN
        SELECT jucator_id, COUNT(*)
        INTO v_id_problema, v_numar_contracte
        FROM Contract_sponsorizare
        GROUP BY jucator_id
        HAVING COUNT(*) > 5
        FETCH FIRST 1 ROW ONLY; -- Lu?m prima eroare g?sit?

        -- Dac? am ajuns aici, înseamn? c? am g?sit un juc?tor cu peste 5 contracte
        RAISE_APPLICATION_ERROR(-20006, 'Eroare la nivel de comanda: Jucatorul cu ID ' || v_id_problema || 
                                        ' a ajuns la ' || v_numar_contracte || ' sponsori. Maximul este 5.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- Totul este în regul?, nu facem nimic
    END;
END;
/


-- Tests

-- Presupunem c? juc?torul cu ID 1 exist? deja

-- Cre?m juc?torul
INSERT INTO Jucator (jucator_id, nume, prenume, nationalitate) 
VALUES (1, 'Gabriel', 'Balaceanu-Nadal', 'Grecia');

-- Cre?m cei 6 sponsori
INSERT INTO Sponsor (sponsor_id, nume) VALUES (101, 'Nike');
INSERT INTO Sponsor (sponsor_id, nume) VALUES (102, 'Adidas');
INSERT INTO Sponsor (sponsor_id, nume) VALUES (103, 'Butterfly');
INSERT INTO Sponsor (sponsor_id, nume) VALUES (104, 'Stiga');
INSERT INTO Sponsor (sponsor_id, nume) VALUES (105, 'Joola');
INSERT INTO Sponsor (sponsor_id, nume) VALUES (106, 'Tibhar');
INSERT INTO Sponsor (sponsor_id, nume) VALUES (107, 'aBiBas');
drop table contract_sponsorizare;

-- Salv?m modific?rile
COMMIT;
select * from jucator;
select * from sponsor;


INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 101, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 102, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 103, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 104, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 105, 5000);

select * from contract_sponsorizare;
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 106, 5000); -- Aici se va declan?a eroarea!
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 107, 6); -- Aici se va declan?a eroarea!


drop table meci;


select * from contract_sponsorizare;
insert into contract_sponsorizare values(1, 1, 10000); 

insert into antrenor values(100, 'Gabi', 'Balaceanu', 'Brazilia');

select * from antrenor;
