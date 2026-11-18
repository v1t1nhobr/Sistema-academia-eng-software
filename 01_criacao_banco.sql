-- PostgreSQL: executar em banco novo academia_eng_software
CREATE TABLE atividades (
 id_atividade BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 nome VARCHAR(100) NOT NULL UNIQUE,
 descricao TEXT
);
CREATE TABLE instrutores (
 id_instrutor BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 rg VARCHAR(30) NOT NULL UNIQUE,
 nome VARCHAR(150) NOT NULL,
 data_nascimento DATE NOT NULL,
 titulacao VARCHAR(120) NOT NULL
);
CREATE TABLE telefones_instrutor (
 id_telefone BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 id_instrutor BIGINT NOT NULL REFERENCES instrutores(id_instrutor) ON DELETE CASCADE,
 numero VARCHAR(25) NOT NULL,
 UNIQUE(id_instrutor, numero)
);
CREATE TABLE alunos (
 matricula VARCHAR(30) PRIMARY KEY,
 data_matricula DATE NOT NULL,
 nome VARCHAR(150) NOT NULL,
 endereco TEXT NOT NULL,
 telefone VARCHAR(25) NOT NULL,
 data_nascimento DATE NOT NULL,
 altura NUMERIC(4,2) NOT NULL CHECK (altura > 0 AND altura < 3),
 peso NUMERIC(6,2) NOT NULL CHECK (peso > 0)
);
CREATE TABLE turmas (
 id_turma BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 id_atividade BIGINT NOT NULL REFERENCES atividades(id_atividade),
 id_instrutor BIGINT NOT NULL REFERENCES instrutores(id_instrutor),
 monitor_matricula VARCHAR(30) NOT NULL UNIQUE REFERENCES alunos(matricula),
 horario_aula TIME NOT NULL,
 duracao_minutos INTEGER NOT NULL CHECK (duracao_minutos > 0),
 data_inicio DATE NOT NULL,
 data_termino DATE NOT NULL,
 capacidade INTEGER NOT NULL CHECK (capacidade > 0),
 CHECK (data_termino >= data_inicio)
);
CREATE TABLE matriculas_turma (
 id_matricula_turma BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 matricula VARCHAR(30) NOT NULL REFERENCES alunos(matricula),
 id_turma BIGINT NOT NULL REFERENCES turmas(id_turma),
 data_inscricao DATE NOT NULL DEFAULT CURRENT_DATE,
 UNIQUE(matricula,id_turma)
);
CREATE TABLE ausencias (
 id_ausencia BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 id_matricula_turma BIGINT NOT NULL REFERENCES matriculas_turma(id_matricula_turma) ON DELETE CASCADE,
 data_aula DATE NOT NULL,
 UNIQUE(id_matricula_turma,data_aula)
);
-- RN: Monitor deve estar matriculado na turma.
-- Trigger de restrição diferível: cadastrar turma e matrícula do monitor na MESMA transação.
CREATE OR REPLACE FUNCTION fn_validar_monitor() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_turma BIGINT; v_monitor VARCHAR(30);
BEGIN
 IF TG_TABLE_NAME = 'turmas' THEN v_turma := NEW.id_turma;
 ELSE v_turma := COALESCE(NEW.id_turma, OLD.id_turma); END IF;
 SELECT monitor_matricula INTO v_monitor FROM turmas WHERE id_turma = v_turma;
 IF FOUND AND NOT EXISTS (
  SELECT 1 FROM matriculas_turma WHERE id_turma = v_turma AND matricula = v_monitor
 ) THEN
  RAISE EXCEPTION 'Monitor % deve estar matriculado na turma %', v_monitor, v_turma;
 END IF;
 RETURN NULL;
END $$;
CREATE CONSTRAINT TRIGGER ct_monitor_turma
 AFTER INSERT OR UPDATE OF monitor_matricula ON turmas
 DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION fn_validar_monitor();
CREATE CONSTRAINT TRIGGER ct_monitor_matricula
 AFTER DELETE OR UPDATE OF matricula, id_turma ON matriculas_turma
 DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION fn_validar_monitor();

-- RN: Limite de vagas; bloqueio da turma serializa matrículas concorrentes.
CREATE OR REPLACE FUNCTION fn_validar_capacidade() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_capacidade INTEGER; v_total BIGINT;
BEGIN
 SELECT capacidade INTO v_capacidade FROM turmas WHERE id_turma = NEW.id_turma FOR UPDATE;
 SELECT COUNT(*) INTO v_total FROM matriculas_turma WHERE id_turma = NEW.id_turma
 AND (TG_OP <> 'UPDATE' OR id_matricula_turma <> NEW.id_matricula_turma);
 IF v_total >= v_capacidade THEN
  RAISE EXCEPTION 'Turma % sem vagas (capacidade: %)', NEW.id_turma, v_capacidade;
 END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER trg_capacidade BEFORE INSERT OR UPDATE OF id_turma ON matriculas_turma
 FOR EACH ROW EXECUTE FUNCTION fn_validar_capacidade();
CREATE OR REPLACE FUNCTION fn_validar_reducao_capacidade() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF NEW.capacidade < (SELECT COUNT(*) FROM matriculas_turma WHERE id_turma = NEW.id_turma) THEN
  RAISE EXCEPTION 'Capacidade menor que a quantidade de alunos matriculados';
 END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER trg_reducao_capacidade BEFORE UPDATE OF capacidade ON turmas
 FOR EACH ROW EXECUTE FUNCTION fn_validar_reducao_capacidade();

-- RN: Ausência somente no intervalo de datas da turma.
CREATE OR REPLACE FUNCTION fn_validar_data_ausencia() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_inicio DATE; v_fim DATE;
BEGIN
 SELECT t.data_inicio,t.data_termino INTO v_inicio,v_fim
 FROM matriculas_turma m JOIN turmas t ON t.id_turma=m.id_turma
 WHERE m.id_matricula_turma=NEW.id_matricula_turma;
 IF NEW.data_aula < v_inicio OR NEW.data_aula > v_fim THEN
  RAISE EXCEPTION 'Data % fora do período da turma (% a %)',NEW.data_aula,v_inicio,v_fim;
 END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER trg_data_ausencia BEFORE INSERT OR UPDATE OF data_aula,id_matricula_turma ON ausencias
 FOR EACH ROW EXECUTE FUNCTION fn_validar_data_ausencia();
CREATE OR REPLACE FUNCTION fn_validar_periodo_turma() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF EXISTS (SELECT 1 FROM ausencias a JOIN matriculas_turma m
 ON m.id_matricula_turma=a.id_matricula_turma WHERE m.id_turma=NEW.id_turma
 AND (a.data_aula < NEW.data_inicio OR a.data_aula > NEW.data_termino)) THEN
  RAISE EXCEPTION 'Novo período da turma invalida ausências existentes';
 END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER trg_periodo_turma BEFORE UPDATE OF data_inicio,data_termino ON turmas
 FOR EACH ROW EXECUTE FUNCTION fn_validar_periodo_turma();
