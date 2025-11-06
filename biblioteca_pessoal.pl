% ============================================================================
% Sistema de Gerenciamento de Biblioteca Pessoal
% Trabalho de Programação em Lógica (Prolog)
% ============================================================================
% Componentes do Grupo:
% - [Arthur Maciel]
% - [Leonardo Fagundes]
% - [Lucas Simão]
% - [João lipao]
% ============================================================================

% ============================================================================
% 3.1. FATOS (Base de Conhecimento)
% ============================================================================

% Definição de livros: livro(Titulo, Autor, Ano, Categoria)
livro('A Arte da Guerra', 'Sun Tzu', 500, 'Estrategia').
livro('O Código Limpo', 'Robert C. Martin', 2008, 'Programacao').
livro('1984', 'George Orwell', 1949, 'Ficcao').
livro('Dom Casmurro', 'Machado de Assis', 1899, 'Literatura').
livro('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943, 'Literatura').
livro('Sapiens', 'Yuval Noah Harari', 2011, 'Historia').

% Definição de autores: autor(Nome, Nacionalidade)
autor('Sun Tzu', 'Chinesa').
autor('Robert C. Martin', 'Americana').
autor('George Orwell', 'Britanica').
autor('Machado de Assis', 'Brasileira').
autor('Antoine de Saint-Exupéry', 'Francesa').
autor('Yuval Noah Harari', 'Israelense').

% Definição de pessoas: pessoa(Nome, Identificador)
pessoa('Maria Silva', 101).
pessoa('João Santos', 202).
pessoa('Ana Costa', 303).
pessoa('Pedro Oliveira', 404).

% Definição de empréstimos: emprestado(Titulo, IdentificadorPessoa, DataEmprestimo)
emprestado('O Código Limpo', 202, '2025-10-20').
emprestado('1984', 101, '2025-10-15').

% ============================================================================
% 3.2. REGRAS (Funcionalidades Essenciais)
% ============================================================================

% livros_por_autor(Autor, Titulo): Retorna todos os títulos escritos por um autor
livros_por_autor(Autor, Titulo) :-
    livro(Titulo, Autor, _, _).

% livros_antigos(AnoMaximo, Titulo): Retorna livros publicados antes ou no ano especificado
livros_antigos(AnoMaximo, Titulo) :-
    livro(Titulo, _, Ano, _),
    Ano =< AnoMaximo.

% disponivel(Titulo): Verifica se o livro NÃO está emprestado (usa negação por falha)
disponivel(Titulo) :-
    livro(Titulo, _, _, _),
    \+ emprestado(Titulo, _, _).

% livros_emprestados_por(NomePessoa, Titulo): Retorna livros emprestados por uma pessoa
livros_emprestados_por(NomePessoa, Titulo) :-
    pessoa(NomePessoa, Identificador),
    emprestado(Titulo, Identificador, _).

% ============================================================================
% REGRAS DE ATUALIZAÇÃO DE DADOS
% ============================================================================

% inserir_livro(Titulo, Autor, Ano, Categoria): Insere um novo livro na base
% Nota: Em Prolog puro, isso requer assert/1. Para uso interativo.
inserir_livro(Titulo, Autor, Ano, Categoria) :-
    \+ livro(Titulo, _, _, _),  % Verifica se o livro não existe
    assert(livro(Titulo, Autor, Ano, Categoria)),
    (\+ autor(Autor, _) -> assert(autor(Autor, 'Desconhecida')) ; true),
    write('Livro inserido com sucesso: '), write(Titulo), nl.

inserir_livro(Titulo, _, _, _) :-
    livro(Titulo, _, _, _),
    write('Erro: Livro já existe na base de dados.'), nl,
    !, fail.

% emprestar_livro(Titulo, IdentificadorPessoa, DataEmprestimo): Registra um empréstimo
emprestar_livro(Titulo, IdentificadorPessoa, DataEmprestimo) :-
    livro(Titulo, _, _, _),
    pessoa(_, IdentificadorPessoa),
    \+ emprestado(Titulo, _, _),  % Verifica se o livro está disponível
    assert(emprestado(Titulo, IdentificadorPessoa, DataEmprestimo)),
    write('Livro emprestado com sucesso: '), write(Titulo), nl.

emprestar_livro(Titulo, _, _) :-
    \+ livro(Titulo, _, _, _),
    write('Erro: Livro não encontrado na base de dados.'), nl,
    !, fail.

emprestar_livro(_, IdentificadorPessoa, _) :-
    \+ pessoa(_, IdentificadorPessoa),
    write('Erro: Pessoa não encontrada na base de dados.'), nl,
    !, fail.

emprestar_livro(Titulo, _, _) :-
    emprestado(Titulo, _, _),
    write('Erro: Livro já está emprestado.'), nl,
    !, fail.

% devolver_livro(Titulo): Remove um empréstimo da base
devolver_livro(Titulo) :-
    emprestado(Titulo, IdentificadorPessoa, DataEmprestimo),
    retract(emprestado(Titulo, IdentificadorPessoa, DataEmprestimo)),
    write('Livro devolvido com sucesso: '), write(Titulo), nl.

devolver_livro(Titulo) :-
    \+ emprestado(Titulo, _, _),
    write('Erro: Livro não está emprestado.'), nl,
    !, fail.

% ============================================================================
% BONUS: INTERFACE DO USUÁRIO
% ============================================================================

% menu_principal: Exibe o menu principal e processa a escolha do usuário
menu_principal :-
    nl,
    write('========================================'), nl,
    write('   SISTEMA DE GERENCIAMENTO DE BIBLIOTECA'), nl,
    write('========================================'), nl,
    nl,
    write('1. Consultar livros por autor'), nl,
    write('2. Consultar livros antigos'), nl,
    write('3. Verificar disponibilidade de livro'), nl,
    write('4. Consultar livros emprestados por pessoa'), nl,
    write('5. Inserir novo livro'), nl,
    write('6. Emprestar livro'), nl,
    write('7. Devolver livro'), nl,
    write('8. Listar todos os livros'), nl,
    write('9. Listar todos os empréstimos'), nl,
    write('0. Sair'), nl,
    nl,
    write('Escolha uma opção: '),
    read(Opcao),
    processar_opcao(Opcao).

% processar_opcao(Opcao): Processa a opção escolhida pelo usuário
processar_opcao(0) :-
    write('Saindo do sistema...'), nl,
    !.

processar_opcao(1) :-
    write('Digite o nome do autor: '),
    read(Autor),
    nl,
    write('Livros de '), write(Autor), write(':'), nl,
    (livros_por_autor(Autor, Titulo) ->
        write('  - '), write(Titulo), nl,
        fail
    ; 
        write('  Nenhum livro encontrado.'), nl
    ),
    aguardar_enter,
    menu_principal.

processar_opcao(2) :-
    write('Digite o ano máximo: '),
    read(AnoMaximo),
    nl,
    write('Livros publicados até '), write(AnoMaximo), write(':'), nl,
    (livros_antigos(AnoMaximo, Titulo) ->
        write('  - '), write(Titulo), nl,
        fail
    ; 
        write('  Nenhum livro encontrado.'), nl
    ),
    aguardar_enter,
    menu_principal.

processar_opcao(3) :-
    write('Digite o título do livro: '),
    read(Titulo),
    nl,
    (disponivel(Titulo) ->
        write('O livro "'), write(Titulo), write('" está DISPONÍVEL.'), nl
    ;
        write('O livro "'), write(Titulo), write('" NÃO está disponível (está emprestado).'), nl
    ),
    aguardar_enter,
    menu_principal.

processar_opcao(4) :-
    write('Digite o nome da pessoa: '),
    read(NomePessoa),
    nl,
    write('Livros emprestados para '), write(NomePessoa), write(':'), nl,
    (livros_emprestados_por(NomePessoa, Titulo) ->
        write('  - '), write(Titulo), nl,
        fail
    ; 
        write('  Nenhum livro emprestado.'), nl
    ),
    aguardar_enter,
    menu_principal.

processar_opcao(5) :-
    write('Digite o título do livro: '),
    read(Titulo),
    write('Digite o autor: '),
    read(Autor),
    write('Digite o ano: '),
    read(Ano),
    write('Digite a categoria: '),
    read(Categoria),
    nl,
    inserir_livro(Titulo, Autor, Ano, Categoria),
    aguardar_enter,
    menu_principal.

processar_opcao(6) :-
    write('Digite o título do livro: '),
    read(Titulo),
    write('Digite o identificador da pessoa: '),
    read(Identificador),
    write('Digite a data do empréstimo (formato: aaaa-mm-dd): '),
    read(Data),
    nl,
    emprestar_livro(Titulo, Identificador, Data),
    aguardar_enter,
    menu_principal.

processar_opcao(7) :-
    write('Digite o título do livro: '),
    read(Titulo),
    nl,
    devolver_livro(Titulo),
    aguardar_enter,
    menu_principal.

processar_opcao(8) :-
    nl,
    write('Todos os livros na biblioteca:'), nl,
    (livro(Titulo, Autor, Ano, Categoria) ->
        write('  - '), write(Titulo), write(' ('), write(Autor), 
        write(', '), write(Ano), write(', '), write(Categoria), write(')'), nl,
        fail
    ; 
        write('  Nenhum livro cadastrado.'), nl
    ),
    aguardar_enter,
    menu_principal.

processar_opcao(9) :-
    nl,
    write('Todos os empréstimos ativos:'), nl,
    (emprestado(Titulo, Identificador, Data) ->
        pessoa(Nome, Identificador),
        write('  - '), write(Titulo), write(' emprestado para '), 
        write(Nome), write(' (ID: '), write(Identificador), 
        write(', Data: '), write(Data), write(')'), nl,
        fail
    ; 
        write('  Nenhum empréstimo ativo.'), nl
    ),
    aguardar_enter,
    menu_principal.

processar_opcao(_) :-
    write('Opção inválida! Tente novamente.'), nl,
    aguardar_enter,
    menu_principal.

% aguardar_enter: Aguarda o usuário pressionar Enter
aguardar_enter :-
    nl,
    write('Pressione Enter para continuar...'),
    read(_).

% iniciar: Inicia o sistema
iniciar :-
    menu_principal.

% ============================================================================
% FIM DO ARQUIVO
% ============================================================================

