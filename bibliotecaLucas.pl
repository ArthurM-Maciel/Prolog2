% ----- Fatos -----

livro('A Arte da Guerra', 'Sun Tzu', -500, 'Estrategia').
livro('Dom Casmurro', 'Machado de Assis', 1899, 'Romance').
livro('O Código Limpo', 'Robert C. Martin', 2008, 'Programacao').
livro('1984', 'George Orwell', 1949, 'Ficcao').
livro('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', 1997, 'Fantasia').


autor('Sun Tzu', 'Chinesa').
autor('Machado de Assis', 'Brasileira').
autor('Robert C. Martin', 'Americana').
autor('George Orwell', 'Britanica').
autor('J.R.R. Tolkien', 'Britanica').


pessoa('Maria Silva', 101).
pessoa('João Pereira', 102).
pessoa('Ana Souza', 103).

emprestado('A Arte da Guerra', 101, '2025-10-20').
emprestado('1984', 102, '2025-10-25').

% ----- Regras -----

livros_por_autor(Autor, Titulo) :-
    livro(Titulo, Autor, _, _).


livros_antigos(AnoMax, Titulo) :-
    livro(Titulo, _, Ano, _),
    Ano =< AnoMax.


disponivel(Titulo) :-
    livro(Titulo, _, _, _),
    \+ emprestado(Titulo, _, _).


livros_emprestados_por(NomePessoa, Titulo) :-
    pessoa(NomePessoa, ID),
    emprestado(Titulo, ID, _).


inserir_livro(Titulo, Autor, Ano, Categoria) :-
    \+ livro(Titulo, _, _, _),
    assertz(livro(Titulo, Autor, Ano, Categoria)).


emprestar_livro(Titulo, NomePessoa, Data) :-
    disponivel(Titulo),
    pessoa(NomePessoa, ID),
    assertz(emprestado(Titulo, ID, Data)).


devolver_livro(Titulo, NomePessoa) :-
    pessoa(NomePessoa, ID),
    retract(emprestado(Titulo, ID, _)).