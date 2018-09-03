/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

inverter([],_).
inverter([H1|T1],L2) :- inverter(T1,[H1|L2]).