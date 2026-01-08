-- Creeare Tabele

CREATE TABLE Sala (
    sala_id NUMBER(10) PRIMARY KEY,
    nume_sala VARCHAR(100) NOT NULL,
    oras VARCHAR(100) NOT NULL,
    capacitate NUMBER(10) NOT NULL
);

-- 1. Tabelul Turneu 
CREATE TABLE Turneu (
    turneu_id NUMBER(10) PRIMARY KEY,
    nume_turneu VARCHAR(100) NOT NULL,
    data_inceput DATE NOT NULL,
    data_final DATE NOT NULL
);

-- 2. Tabelul Arbitru
CREATE TABLE Arbitru (
    arbitru_id NUMBER(10) PRIMARY KEY,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    nationalitate VARCHAR(50) NOT NULL
);

-- 3. Tabelul Jucator
CREATE TABLE Jucator (
    jucator_id NUMBER(10) PRIMARY KEY,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    nationalitate VARCHAR(50) NOT NULL
);

-- 4. Tabelul Paleta 
CREATE TABLE Paleta (
    paleta_id NUMBER(10) PRIMARY KEY,
    jucator_id NUMBER(10),
    tip_lemn VARCHAR(50) NOT NULL,
    tip_cauciuc_negru VARCHAR(50) NOT NULL,
    tip_cauciuc_rosu VARCHAR(50) NOT NULL,
    FOREIGN KEY (jucator_id) REFERENCES Jucator(jucator_id)
);

-- 5. Tabelul Meci 
CREATE TABLE Meci (
    meci_id NUMBER(10) PRIMARY KEY,
    jucator_unu NUMBER(10) NOT NULL,
    jucator_doi NUMBER(10) NOT NULL,
    turneu_id NUMBER(10) NOT NULL,
    arbitru_id NUMBER(10) NOT NULL,
    sala_id NUMBER(10) NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (jucator_unu) REFERENCES Jucator(jucator_id),
    FOREIGN KEY (jucator_doi) REFERENCES Jucator(jucator_id),
    FOREIGN KEY (turneu_id) REFERENCES Turneu(turneu_id),
    FOREIGN KEY (arbitru_id) REFERENCES Arbitru(arbitru_id),
    FOREIGN KEY (sala_id) REFERENCES Sala(sala_id),
    CONSTRAINT chk_jucatori_diferiti CHECK (jucator_unu <> jucator_doi)
);

-- 6. Tabelul Antrenor
CREATE TABLE Antrenor (
    antrenor_id NUMBER(10) PRIMARY KEY,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    nationalitate VARCHAR(50) NOT NULL
);

-- 7. Tabelul Sponsor
CREATE TABLE Sponsor (
    sponsor_id NUMBER(10) PRIMARY KEY,
    nume VARCHAR(100) NOT NULL
);

-- 8. Tabelul Contract_antrenor
CREATE TABLE Contract_antrenor (
    antrenor_id NUMBER(10),
    jucator_id NUMBER(10),
    data_inceput DATE NOT NULL,
    data_final DATE NOT NULL,
    PRIMARY KEY (antrenor_id, jucator_id),
    FOREIGN KEY (antrenor_id) REFERENCES Antrenor(antrenor_id),
    FOREIGN KEY (jucator_id) REFERENCES Jucator(jucator_id)
);

-- 9. Tabelul Contract_sponsorizare
CREATE TABLE Contract_sponsorizare (
    jucator_id NUMBER(10),
    sponsor_id NUMBER(10),
    suma NUMBER(10, 2) NOT NULL,
    PRIMARY KEY (jucator_id, sponsor_id),
    FOREIGN KEY (jucator_id) REFERENCES Jucator(jucator_id),
    FOREIGN KEY (sponsor_id) REFERENCES Sponsor(sponsor_id)
);



