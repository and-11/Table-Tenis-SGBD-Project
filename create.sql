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

