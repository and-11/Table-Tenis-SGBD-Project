

select * from Contract_sponsorizare;
drop table Contract_sponsorizare;

select * from turneu;




INSERT INTO Turneu (turneu_id, nume_turneu, data_inceput, data_final)
VALUES (
    2, 
    'Campionatul Judetean Vaslui de Tenis de Masa', 
    TO_DATE('10-03-2025', 'DD-MM-YYYY'),
    TO_DATE('15-03-1999', 'DD-MM-YYYY')
);




INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 103, -5000);


select * from jucator;
select * from sponsor;
select * from Contract_sponsorizare;



INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 104, 5000);
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 105, 5000);

select * from contract_sponsorizare;
INSERT INTO Contract_sponsorizare (jucator_id, sponsor_id, suma) VALUES (1, 106, 5000);



