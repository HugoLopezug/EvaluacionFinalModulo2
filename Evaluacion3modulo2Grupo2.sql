-- Usuario primera tabla, no tiene pk.  

CREATE SEQUENCE id_seq;

CREATE TABLE usuarios 
(urun NUMBER (9) NOT NULL, 
usunombre VARCHAR2(30) NOT NULL, 
usuapellido VARCHAR2(50) NOT NULL, 
usufechanacimiento DATE NOT NULL, 
CONSTRAINT usuarios_pk PRIMARY KEY (urun)
);
      
INSERT into usuarios values ('152345642','Julio Andres','Assange Clus',to_date('11/03/1979','DD/MM/YYYY'));
INSERT into usuarios values ('122349872','Andres Juan','Calamaro Gates',to_date('19/04/1971','DD/MM/YYYY'));
INSERT into usuarios values ('164785474','Marianela Andrea','Herrera Santos',to_date('01/03/1985','DD/MM/YYYY'));
      
-- cliente y sus llaves , ordenados desde arriba hacia abajo y desde izquierda a derecha segun modelo relacional     
      
CREATE TABLE cliente 
(rutcliente NUMBER (9) NOT NULL, 
clinombres VARCHAR2(30) NOT NULL, 
cliapellidos VARCHAR2(50) NOT NULL, 
clitelefono VARCHAR2(20) NOT NULL, 
cliafp VARCHAR2(30), 
clisistemasalud NUMBER (2),
clidireccion VARCHAR2(100),
clicomuna VARCHAR2(50),
cliedad NUMBER (3) NOT NULL,
usuario_urun NUMBER(9) NOT NULL,
CONSTRAINT cliente_pk PRIMARY KEY (rutcliente),
CONSTRAINT cliente_fk FOREIGN KEY (usuario_urun) REFERENCES usuarios
);

INSERT into cliente values ('172576265','Joel Andres','Rodriguez Jara','913657879','Cuprum','2','Las parcelas #124','Valparaiso','31','122349872');
INSERT into cliente values ('142636573','Julia Mariana','Aldunate Muñoz','976523119','Habitad','2','Av el Rodeo #546','Las Condes','42','152345642');
INSERT into cliente values ('98754585','Mario Luciano','Barra Lara','978894115','Capital','2','Gustavo Frank #1254','Valparaiso','31','122349872');

-- desde la izquierda por cliente, primera linea hacia abajo según modelo relacional: pagos. 

CREATE TABLE pagos
(idpagos NUMBER(9) NOT NULL, 
pagofecha DATE NOT NULL, 
pagomonto NUMBER(10)NOT NULL,	
pagomes VARCHAR2(2), 
pagoaño number(4), 
cliente_rutcliente NUMBER(9)NOT NULL,
CONSTRAINT pagos_pk PRIMARY KEY (idpagos),
CONSTRAINT pagos_fk FOREIGN KEY (cliente_rutcliente) REFERENCES cliente
);

CREATE OR REPLACE TRIGGER idpagos_bir 
BEFORE INSERT ON pagos 
FOR EACH ROW
WHEN (new.idpagos IS NULL) 
BEGIN 
    SELECT id_seq.NEXTVAL 
    INTO :new.idpagos
    FROM dual;
END; 

-- desde la izquierda por client, segunda linea hacia abajo según modelo relacional: visita, chequeos y estadocumplimiento 

CREATE TABLE visita 
(idvisita NUMBER (9 )NOT NULL,  
visfecha date NOT NULL,
vishora date, 
vislugar VARCHAR2(50) NOT NULL, 
viscomentarios VARCHAR2 (250) NOT NULL, 
cliente_rutcliente NUMBER(9) NOT NULL,
CONSTRAINT visita_pk PRIMARY KEY (idvisita),
CONSTRAINT visita_fk FOREIGN KEY (cliente_rutcliente) REFERENCES cliente
);
   
CREATE TABLE chequeos 
(idchequeo NUMBER (9) NOT NULL,  
chenombre VARCHAR2(20) NOT NULL,
visita_idvisita NUMBER (9 )NOT NULL,
CONSTRAINT chequeos_pk PRIMARY KEY (idchequeo),
CONSTRAINT cequeos_fk FOREIGN KEY (visita_idvisita) REFERENCES visita
);
   
CREATE TABLE estadoCumplimiento 
(cumplimiento VARCHAR2(2) NOT NULL,  
observacion VARCHAR2(100),
chequeos_idchequeo NUMBER (9) NOT NULL,
CONSTRAINT estadocumplimiento_pk PRIMARY KEY (chequeos_idchequeo),
CONSTRAINT estadocumplimiento_fk FOREIGN KEY (chequeos_idchequeo) REFERENCES chequeos
);

-- desde la izquierda por cliente, tercera linea hacia abajo según modelo relacional: accidente

CREATE TABLE accidente
(idaccidente NUMBER(9) not null, 
accifecha DATE NOT NULL, 
accihora DATE NOT NULL, 
accilugar VARCHAR2(50) NOT NULL, 
acciorigen VARCHAR2(100) NOT NULL, 
acciconsecuencias VARCHAR2(100),
cliente_rutcliente NUMBER(9)NOT NULL,
CONSTRAINT accidente_pk PRIMARY KEY (idaccidente),
CONSTRAINT accidente_fk FOREIGN KEY (cliente_rutcliente) REFERENCES cliente
);

-- desde la izquierda por cliente, cuarta linea hacia abajo según modelo relacional: capacitacion y asistentes.  

CREATE TABLE capacitacion 
(idcapacitacion NUMBER(9) NOT NULL, 
caocapfecha DATE NOT NULL, 
caphora DATE NOT NULL, 
caplugar VARCHAR2(100) NOT NULL, 
capduracion NUMBER(4) NOT NULL, 
capcantidadasistentes NUMBER(4) NOT NULL,
cliente_rutcliente NUMBER(9)NOT NULL,
CONSTRAINT capacitacion_pk PRIMARY KEY (idcapacitacion),
CONSTRAINT capacitacion_fk FOREIGN KEY (cliente_rutcliente) REFERENCES cliente
);
   
CREATE TABLE asistentes 
(idasistente NUMBER (9), 
asistnombrecompleto VARCHAR2(100) NOT NULL, 
asistedad NUMBER(3) NOT NULL,
asistcorreo VARCHAR2(70),
asittelefono VARCHAR2(20),
capacitacion_idcapacitacion NUMBER(9),
CONSTRAINT asistentes_pk PRIMARY KEY (idasistente),
CONSTRAINT asistentes_fk FOREIGN KEY (capacitacion_idcapacitacion) REFERENCES capacitacion
);
  
-- profesional y sus llaves compartidas con clientes, ordenados desde arriba hacia abajo segun modelo relacional 

CREATE TABLE profesionales 
(prorun NUMBER (9) NOT NULL, 
pronombres VARCHAR2(30) NOT NULL, 
proapellidos VARCHAR2(50) NOT NULL, 
protelefono VARCHAR2(20) NOT NULL, 
protitulo VARCHAR2(30), 
proproyecto VARCHAR2(30),
usuario_urun NUMBER(9) NOT NULL,
CONSTRAINT profesionales_pk PRIMARY KEY (prorun),
CONSTRAINT profesionales_fk FOREIGN KEY (usuario_urun) REFERENCES usuarios
);
   
INSERT into profesionales values ('122347862','Jose Lilio','Hernandez Campos','964326554','Ing.Prevencion de riesgos','disminucion caida mismo nivel','164785474');
INSERT into profesionales values ('174578569','Maria Jose','Vielma Soto','945458811','Ing Civil Industrial','generacion de AST','152345642');
INSERT into profesionales values ('184575887','Catalina Paz','Marras Campos','956447833','Psicologia Laboral','Pausas no activas por area','164785474');
   
-- Tablas deribadas de profesional y cliente de arriba hacia abajo segun modelo relaciona: Asesoria y mejora   
   
CREATE TABLE asesoria
(idasesoria NUMBER (9) NOT NULL, 
asefecha date NOT NULL, 
asemotivo VARCHAR2(250), 
profesional_prorun NUMBER(9) NOT NULL,
cliente_rutcliente NUMBER(9)NOT NULL,
CONSTRAINT asesoria_pk PRIMARY KEY (idasesoria),
CONSTRAINT asesoria_profesionales_fk FOREIGN KEY (profesional_prorun) REFERENCES profesionales,
CONSTRAINT asesoria_cliente_fk FOREIGN KEY (cliente_rutcliente) REFERENCES cliente
);  
 
CREATE TABLE mejora 
(idmejora NUMBER (9) NOT NULL, 
mejortitulo VARCHAR2(50)NOT NULL, 
mejordescripcion VARCHAR2(50) NOT NULL,
mejorplazo date,
asesoria_idasesoria NUMBER(9)NOT NULL,
CONSTRAINT mejora_pk PRIMARY KEY (idmejora),
CONSTRAINT mejora_fk FOREIGN KEY (asesoria_idasesoria) REFERENCES asesoria
);  

CREATE OR REPLACE TRIGGER idmejora_bir 
BEFORE INSERT ON mejora 
FOR EACH ROW
WHEN (new.idmejora IS NULL) 
BEGIN 
    SELECT id_seq.NEXTVAL 
    INTO :new.idmejora
    FROM dual;
END;

-- Administrativo, ultima tabla desde izquierda a derecha segun modelo relacional  
   
CREATE TABLE administrativos
(adrun NUMBER (9) NOT NULL, 
adnombres VARCHAR2(30) NOT NULL, 
adapellidos VARCHAR2(50) NOT NULL, 
adcorreo VARCHAR2(50) NOT NULL, 
adarea VARCHAR2(30), 
usuario_urun NUMBER(9) NOT NULL,
CONSTRAINT administrativo_pk PRIMARY KEY (adrun),
CONSTRAINT administrativo_fk FOREIGN KEY (usuario_urun) REFERENCES usuarios
);
   
  
    
 

    