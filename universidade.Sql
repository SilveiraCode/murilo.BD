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
CREATE PROCEDURE sp_matricular_aluno
    @p_matricula INT,
    @p_curso CHAR(3),
    @p_perletivo INT
AS
BEGIN

    INSERT INTO MATRICULA (MATRICULA, CURSO, MATERIA, PROFESSOR, PERLETIVO)
    SELECT 
        @p_matricula, 
        m.CURSO, 
        m.SIGLA, 
        m.PROFESSOR, 
        @p_perletivo
    FROM MATERIAS m
    WHERE m.CURSO = @p_curso
      AND NOT EXISTS (
          SELECT 1 FROM MATRICULA ma
          WHERE ma.MATRICULA = @p_matricula
            AND ma.CURSO = m.CURSO
            AND ma.MATERIA = m.SIGLA
            AND ma.PROFESSOR = m.PROFESSOR
            AND ma.PERLETIVO = @p_perletivo
      );
END;
GO
CREATE PROCEDURE sp_LANCANOTAS
    @p_MATRICULA INT,
    @p_CURSO CHAR(3),
    @p_MATERIA CHAR(8),
    @p_PERLETIVO CHAR(4),
    @p_NOTA FLOAT,
    @p_FALTA INT,
    @p_BIMESTRE INT
AS
BEGIN

    DECLARE 
        @v_RESULTADO VARCHAR(20),
        @v_FREQUENCIA FLOAT,
        @v_CARGAHORA INT,
        @v_N1 FLOAT = 0,
        @v_N2 FLOAT = 0,
        @v_N3 FLOAT = 0,
        @v_N4 FLOAT = 0,
        @v_F1 INT = 0,
        @v_F2 INT = 0,
        @v_F3 INT = 0,
        @v_F4 INT = 0,
        @v_TOTAL_PONTOS FLOAT,
        @v_TOTAL_FALTAS INT,
        @v_MEDIA_FINAL FLOAT;

    IF @p_BIMESTRE = 1
    BEGIN
        UPDATE MATRICULA
        SET N1 = @p_NOTA, F1 = @p_FALTA
        WHERE MATRICULA = @p_MATRICULA AND CURSO = @p_CURSO AND MATERIA = @p_MATERIA AND PERLETIVO = @p_PERLETIVO;
    END
    ELSE IF @p_BIMESTRE = 2
    BEGIN
        UPDATE MATRICULA
        SET N2 = @p_NOTA, F2 = @p_FALTA
        WHERE MATRICULA = @p_MATRICULA AND CURSO = @p_CURSO AND MATERIA = @p_MATERIA AND PERLETIVO = @p_PERLETIVO;
    END
    ELSE IF @p_BIMESTRE = 3
    BEGIN
        UPDATE MATRICULA
        SET N3 = @p_NOTA, F3 = @p_FALTA
        WHERE MATRICULA = @p_MATRICULA AND CURSO = @p_CURSO AND MATERIA = @p_MATERIA AND PERLETIVO = @p_PERLETIVO;
    END
    ELSE IF @p_BIMESTRE = 4
    BEGIN
        UPDATE MATRICULA
        SET N4 = @p_NOTA, F4 = @p_FALTA
        WHERE MATRICULA = @p_MATRICULA AND CURSO = @p_CURSO AND MATERIA = @p_MATERIA AND PERLETIVO = @p_PERLETIVO;

        -- BLOCO PARA COLETAR OS DADOS
        SELECT 
            @v_N1 = N1, @v_N2 = N2, @v_N3 = N3, @v_N4 = N4,
            @v_F1 = F1, @v_F2 = F2, @v_F3 = F3, @v_F4 = F4
        FROM MATRICULA
        WHERE MATRICULA = @p_MATRICULA AND CURSO = @p_CURSO AND MATERIA = @p_MATERIA AND PERLETIVO = @p_PERLETIVO;

        -- BLOCO PARA COLETAR A CARGAHORARIA
        SELECT @v_CARGAHORA = CARGAHORARIA
        FROM MATERIAS
        WHERE SIGLA = @p_MATERIA AND CURSO = @p_CURSO;

        -- BLOCO PARA SETAR AS VARIÁVEIS
        SET @v_TOTAL_PONTOS = ISNULL(@v_N1,0) + ISNULL(@v_N2,0) + ISNULL(@v_N3,0) + ISNULL(@v_N4,0);
        SET @v_TOTAL_FALTAS = ISNULL(@v_F1,0) + ISNULL(@v_F2,0) + ISNULL(@v_F3,0) + ISNULL(@v_F4,0);
        SET @v_FREQUENCIA = 100.0 - ((@v_TOTAL_FALTAS * 100.0) / @v_CARGAHORA);
        SET @v_MEDIA_FINAL = @v_TOTAL_PONTOS / 4.0;

        -- Determinar resultado
        IF @v_FREQUENCIA < 75
            SET @v_RESULTADO = 'REPROVADO';
        ELSE IF @v_MEDIA_FINAL >= 7 AND @v_FREQUENCIA >= 75
            SET @v_RESULTADO = 'APROVADO';
        ELSE IF @v_MEDIA_FINAL < 3
            SET @v_RESULTADO = 'REPROVADO';
        ELSE 
            SET @v_RESULTADO = 'EXAME';

        -- Atualizar tabela
        UPDATE MATRICULA
        SET 
            TOTALPONTOS = @v_TOTAL_PONTOS,
            TOTALFALTAS = @v_TOTAL_FALTAS,
            MEDIA = @v_MEDIA_FINAL,
            PERCFREQ = @v_FREQUENCIA,
            RESULTADO = @v_RESULTADO
        WHERE MATRICULA = @p_MATRICULA AND CURSO = @p_CURSO AND MATERIA = @p_MATERIA AND PERLETIVO = @p_PERLETIVO;
    END

    -- Retornar os dados atualizados
    SELECT * FROM MATRICULA WHERE MATRICULA = @p_MATRICULA;
END;
GO
CREATE PROCEDURE sp_LANCAEXAME
    @p_MATRICULA INT,
    @p_CURSO CHAR(3),
    @p_MATERIA CHAR(8),
    @p_PERLETIVO CHAR(4),
    @p_NOTA_EXAME FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @v_TOTAL_PONTOS FLOAT,
        @v_MEDIA_FINAL FLOAT,
        @v_RESULTADO_ATUAL VARCHAR(20);

    -- Buscar o resultado atual do aluno na tabela MATRICULA
    SELECT @v_RESULTADO_ATUAL = RESULTADO
    FROM MATRICULA
    WHERE MATRICULA = @p_MATRICULA
      AND CURSO = @p_CURSO
      AND MATERIA = @p_MATERIA
      AND PERLETIVO = @p_PERLETIVO;

    -- Verifica se o aluno está em exame
    IF @v_RESULTADO_ATUAL = 'EXAME'
    BEGIN
        -- Buscar TOTALPONTOS já calculado anteriormente
        SELECT @v_TOTAL_PONTOS = TOTALPONTOS
        FROM MATRICULA
        WHERE MATRICULA = @p_MATRICULA
          AND CURSO = @p_CURSO
          AND MATERIA = @p_MATERIA
          AND PERLETIVO = @p_PERLETIVO;

        SET @v_MEDIA_FINAL = ISNULL(@v_TOTAL_PONTOS, 0) + @p_NOTA_EXAME;

        -- Avaliar aprovação com base na soma das notas de média e exame
        IF @v_MEDIA_FINAL >= 10
            SET @v_RESULTADO_ATUAL = 'APROVADO';
        ELSE
            SET @v_RESULTADO_ATUAL = 'REPROVADO';

        -- Atualizar os dados na tabela
        UPDATE MATRICULA
        SET NOTAEXAME = @p_NOTA_EXAME,
            MEDIAFINAL = @v_MEDIA_FINAL,
            RESULTADO = @v_RESULTADO_ATUAL
        WHERE MATRICULA = @p_MATRICULA
          AND CURSO = @p_CURSO
          AND MATERIA = @p_MATERIA
          AND PERLETIVO = @p_PERLETIVO;
    END
    ELSE
    BEGIN
        -- Se não está em exame, apenas retorna uma mensagem
        SELECT 'Aluno não está em exame.' AS mensagem;
    END

    -- Exibir dados atualizados
    SELECT * FROM MATRICULA
    WHERE MATRICULA = @p_MATRICULA
      AND CURSO = @p_CURSO
      AND MATERIA = @p_MATERIA
      AND PERLETIVO = @p_PERLETIVO;
END;
GO
