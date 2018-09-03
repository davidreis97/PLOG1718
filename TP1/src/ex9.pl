/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

aluno(joao, paradigmas).
aluno(maria, paradigmas).
aluno(joel, lab2).
aluno(joel, estruturas).

frequenta(joao, feup).
frequenta(maria, feup).
frequenta(joel, ist).

professor(carlos, paradigmas).
professor(ana_paula, estruturas).
professor(pedro, lab2).

funcionario(pedro, ist).
funcionario(ana_paula, feup).
funcionario(carlos, feup).

exA(Prof,Aluno) :- aluno(Aluno,Disciplina), professor(Prof,Disciplina), funcionario(Prof,Uni), frequenta(Aluno,Uni).

exB(Uni, Pessoa) :- frequenta(Pessoa,Uni).
exB(Uni, Pessoa) :- funcionario(Pessoa,Uni).

exC(PessoaA,PessoaB) :- aluno(PessoaA,Disc), aluno(PessoaB,Disc), frequenta(PessoaA,Uni), frequenta(PessoaB,Uni), PessoaA \= PessoaB.
exC(PessoaA,PessoaB) :- funcionario(PessoaA,Uni), funcionario(PessoaB,Uni), PessoaA \= PessoaB.
