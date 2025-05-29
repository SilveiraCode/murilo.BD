CREATE DATABASE Universidade;
GO

USE Universidade;
GO

-- Tabela ALUNOS
CREATE TABLE ALUNOS (
    MATRICULA INT NOT NULL IDENTITY(1,1)
        CONSTRAINT PK_ALUNO PRIMARY KEY,
    NOME VARCHAR(50) NOT NULL
);
GO

-- Tabela CURSOS
CREATE TABLE CURSOS (
    CURSO CHAR(3) NOT NULL
        CONSTRAINT PK_CURSO PRIMARY KEY,
    NOME VARCHAR(50) NOT NULL
);
GO

-- Tabela PROFESSOR
CREATE TABLE PROFESSOR (
    PROFESSOR INT NOT NULL IDENTITY(1,1)
        CONSTRAINT PK_PROFESSOR PRIMARY KEY,
    NOME VARCHAR(50) NOT NULL
);
GO

-- Tabela MATERIAS
CREATE TABLE MATERIAS (
    SIGLA CHAR(8) NOT NULL,
    NOME VARCHAR(50) NOT NULL,
    CARGAHORARIA INT NOT NULL,
    CURSO CHAR(3) NOT NULL,
    PROFESSOR INT,
    CONSTRAINT PK_MATERIA PRIMARY KEY (SIGLA, CURSO, PROFESSOR),
    CONSTRAINT FK_CURSO FOREIGN KEY (CURSO) REFERENCES CURSOS (CURSO),
    CONSTRAINT FK_PROFESSOR FOREIGN KEY (PROFESSOR) REFERENCES PROFESSOR (PROFESSOR)
);
GO

-- Inserção de alunos
INSERT INTO ALUNOS (NOME) VALUES ('gustavo');
INSERT INTO ALUNOS (NOME) VALUES ('murilo');
GO

-- Inserção de cursos
INSERT INTO CURSOS (CURSO, NOME) VALUES 
('SIS', 'Sistemas'),
('ENG', 'Engenharia'),
('ADS', 'Análise e Desenvolvimento de Sistemas'),
('ADM', 'Administração');
GO
-- Inserção de professores
INSERT INTO PROFESSOR (NOME) VALUES 
('Amanda'),
('Gabriel'),
('Fernanda'),
('Eduardo'),
('Tatiane'),
('Bruno'),
('Isabela'),
('Marcos'),
('Patrícia'),
('Felipe'),
('Renata'),
('Roberto'),
('Camila'),
('Thiago'),
('Aline'),
('Luciano'),
('Vanessa'),
('Rafael');
GO
-- Inserção de matérias
-- Carga horária está em quantidade de aulas    
INSERT INTO MATERIAS (SIGLA, NOME, CARGAHORARIA, CURSO, PROFESSOR) VALUES
-- Matérias de ADS
('POOADS', 'Programação Orientada a Objetos', 72, 'ADS', 13),
('BDIADS', 'Banco de Dados I', 72, 'ADS', 16),
('WEBF', 'Desenvolvimento Web Front-End', 72, 'ADS', 14),
('ALGOADS', 'Algoritmos e Estruturas de Dados', 72, 'ADS', 15),
('UXD', 'Experiência do Usuário e Design', 72, 'ADS', 11),
('SEGINFO', 'Segurança da Informação', 72, 'ADS', 17),
('PIADS', 'Projeto Integrador ADS', 72, 'ADS', 18),

-- Matérias de ADM
('ADMFIN', 'Administração Financeira', 72, 'ADM', 1),
('MRKT', 'Marketing e Vendas', 72, 'ADM', 2),
('RHORG', 'Gestão de Pessoas e Organizações', 72, 'ADM', 3),
('LOGADM', 'Logística Empresarial', 72, 'ADM', 4),
('ESTAT', 'Estatística Aplicada', 72, 'ADM', 5),
('DIREMP', 'Direito Empresarial', 72, 'ADM', 7),
('PIADM', 'Projeto Integrador ADM', 72, 'ADM', 9),

-- Matérias de SIS (mantidas)
('POOI', 'Programação Orientada a Objetos', 72, 'SIS', 13),
('APSII', 'Análise e Projetos de Sistemas II', 72, 'SIS', 14),
('ARC', 'Arquitetura de Computadores', 72, 'SIS', 15),
('BDII', 'Banco de Dados II', 72, 'SIS', 16),
('EIXIII', 'Sociedade e Meio Ambiente', 72, 'SIS', 17),
('VEPIII', 'Vivências de Extensão-Projeto Integrador', 72, 'SIS', 18),

-- Matérias de ENG (mantidas)
('POOI', 'Programação Orientada a Objetos', 72, 'ENG', 13),
('ERPS', 'Engenharia de Requisitos', 72, 'ENG', 15),
('ARC', 'Arquitetura de Computadores', 72, 'ENG', 15),
('BDII', 'Banco de Dados II', 72, 'ENG', 16),
('EIXIII', 'Sociedade e Meio Ambiente', 72, 'ENG', 17),
('VEPIII', 'Vivências de Extensão-Projeto Integrador', 72, 'ENG', 18);
GO

-- Tabela de matrícula
CREATE TABLE MATRICULA (
    MATRICULA INT NOT NULL,
    CURSO CHAR(3) NOT NULL,
    MATERIA CHAR(8) NOT NULL,
    PROFESSOR INT NOT NULL,
    PERLETIVO INT NOT NULL,
    N1 FLOAT, N2 FLOAT, N3 FLOAT, N4 FLOAT,
    F1 INT, F2 INT, F3 INT, F4 INT,
    TOTALPONTOS FLOAT,
    TOTALFALTAS INT,
    MEDIA FLOAT,
    PERCFREQ FLOAT,
    RESULTADO VARCHAR(20),
    NOTAEXAME FLOAT,
    MEDIAFINAL FLOAT,
    CONSTRAINT PK_MATRICULA PRIMARY KEY (MATRICULA, CURSO, MATERIA, PROFESSOR, PERLETIVO),
    FOREIGN KEY (MATRICULA) REFERENCES ALUNOS(MATRICULA),
    FOREIGN KEY (CURSO) REFERENCES CURSOS(CURSO),
    FOREIGN KEY (PROFESSOR) REFERENCES PROFESSOR(PROFESSOR)
);
GO
