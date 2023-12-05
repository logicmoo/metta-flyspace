:- encoding(iso_latin_1).
%:- '$set_source_module'('user').
:- set_stream(user_input,tty(true)).
:- use_module(library(readline)).
:- use_module(library(editline)).
:- use_module(library(filesex)).
:- use_module(library(shell)).
%:- use_module(library(tabling)).
:- use_module(library(system)).
:- ensure_loaded(metta_compiler).
%:- ensure_loaded(metta_types).
:- ensure_loaded(metta_data).
:- ensure_loaded(metta_space).
:- ensure_loaded(metta_eval).
:- set_stream(user_input,tty(true)).
:- set_prolog_flag(encoding,iso_latin_1).
:- set_prolog_flag(encoding,utf8).
%:- set_prolog_flag(encoding,octet).
/*
Now PASSING NARS.TEC:\opt\logicmoo_workspace\packs_sys\logicmoo_opencog\MeTTa\vspace-metta\metta_vspace\pyswip\metta_interp.pl
C:\opt\logicmoo_workspace\packs_sys\logicmoo_opencog\MeTTa\vspace-metta\metta_vspace\pyswip1\metta_interp.pl
STS1.01)
Now PASSING TEST-SCRIPTS.B5-TYPES-PRELIM.08)
Now PASSING TEST-SCRIPTS.B5-TYPES-PRELIM.14)
Now PASSING TEST-SCRIPTS.B5-TYPES-PRELIM.15)
Now PASSING TEST-SCRIPTS.C1-GROUNDED-BASIC.15)
Now PASSING TEST-SCRIPTS.E2-STATES.08)
PASSING TEST-SCRIPTS.B5-TYPES-PRELIM.02)
PASSING TEST-SCRIPTS.B5-TYPES-PRELIM.07)
PASSING TEST-SCRIPTS.B5-TYPES-PRELIM.09)
PASSING TEST-SCRIPTS.B5-TYPES-PRELIM.11)
PASSING TEST-SCRIPTS.C1-GROUNDED-BASIC.14)
PASSING TEST-SCRIPTS.E2-STATES.07)
-----------------------------------------
FAILING TEST-SCRIPTS.D5-AUTO-TYPES.01)
Now FAILING TEST-SCRIPTS.00-LANG-CASE.03)
Now FAILING TEST-SCRIPTS.B5-TYPES-PRELIM.19)
Now FAILING TEST-SCRIPTS.C1-GROUNDED-BASIC.20)

*/


option_value_def('repl',false).
option_value_def('compile',false).
option_value_def('table',false).
option_value_def(no_repeats,false).
option_value_def('time',true).
option_value_def('exec',true).
option_value_def('html',false).
option_value_def('python',load).
option_value_def('halt',false).
option_value_def('prolog',false).
option_value_def('doing_repl',false).
option_value_def('test-retval',false).
option_value_def('trace-length',100).
option_value_def('stack-max',100).
option_value_def('trace-on-overtime',20.0).
option_value_def('trace-on-overflow',false).
option_value_def('trace-on-error',true).
option_value_def('trace-on-load',true).
option_value_def('trace-on-fail',false).
option_value_def('trace-on-pass',false).
option_value_def('trace-on-eval',false).
option_value_def('trace-on-exec',true).



set_is_unit_test(TF):-
  set_option_value('trace-on-load',TF),
  set_option_value('trace-on-exec',TF),
  set_option_value('trace-on-eval',TF),
  set_option_value('trace-on-pass',false),
  set_option_value('trace-on-fail',false),
  !.

:- set_is_unit_test(true).
%:- set_is_unit_test.

trace_on_fail:-     option_value('trace-on-fail',true).
trace_on_overflow:- option_value('trace-on-overflow',true).
trace_on_pass:-     option_value('trace-on-pass',true).
doing_repl:-     option_value('doing_repl',true).
if_repl(Goal):- doing_repl->call(Goal);true.

any_floats(S):- member(E,S),float(E),!.

% ============================
% %%%% Arithmetic Operations
% ============================
%:- use_module(library(clpfd)).
:- use_module(library(clpq)).
%:- use_module(library(clpr)).

% Addition
%'+'(Addend1, Addend2, Sum):- \+ any_floats([Addend1, Addend2, Sum]),!,Sum #= Addend1+Addend2 .
'+'(Addend1, Addend2, Sum):- catch(plus(Addend1, Addend2, Sum),_,fail),!.
'+'(Addend1, Addend2, Sum):- {Sum = Addend1+Addend2}.
% Subtraction
'-'(Sum, Addend1, Addend2):- '+'(Addend1, Addend2, Sum).

% Multiplication
'*'(Factor1, Factor2, Product):- {Product = Factor1*Factor2}.
% Division
'/'(Dividend, Divisor, Quotient):- {Dividend = Quotient * Divisor}.
% Modulus
'mod'(Dividend, Divisor, Remainder):- {Remainder = Dividend mod Divisor}.
% Exponentiation
'exp'(Base, Exponent, Result):- eval_args(['exp', Base, Exponent], Result).
% Square Root
'sqrt'(Number, Root):- eval_args(['sqrt', Number], Root).

% ============================
% %%%% List Operations
% ============================
% Retrieve Head of the List
'car-atom'(List, Head):- eval_args(['car-atom', List], Head).
% Retrieve Tail of the List
'cdr-atom'(List, Tail):- eval_args(['cdr-atom', List], Tail).
% Construct a List
'Cons'(Element, List, 'Cons'(Element, List)):- !.
% Collapse List
'collapse'(List, CollapsedList):- eval_args(['collapse', List], CollapsedList).
% Count Elements in List
'CountElement'(List, Count):- eval_args(['CountElement', List], Count).
% Find Length of List
%'length'(List, Length):- eval_args(['length', List], Length).

% ============================
% %%%% Nondet Opteration
% ============================
% Superpose a List
%'superpose'(List, SuperposedList):- eval_args(['superpose', List], SuperposedList).

% ============================
% %%%% Testing
% ============================

% `assertEqual` Predicate
% This predicate is used for asserting that the Expected value is equal to the Actual value.
% Expected: The value that is expected.
% Actual: The value that is being checked against the Expected value.
% Result: The result of the evaluation of the equality.
% Example: `assertEqual(5, 5, Result).` would succeed, setting Result to true (or some success indicator).
%'assertEqual'(Expected, Actual, Result):- use_metta_compiler,!,as_tf((Expected=Actual),Result).
'assertEqual'(Expected, Actual, Result):- ignore(Expected=Actual), eval_args(['assertEqual', Expected, Actual], Result).

% `assertEqualToResult` Predicate
% This predicate asserts that the Expected value is equal to the Result of evaluating Actual.
% Expected: The value that is expected.
% Actual: The expression whose evaluation is being checked against the Expected value.
% Result: The result of the evaluation of the equality.
% Example: If Actual evaluates to the Expected value, this would succeed, setting Result to true (or some success indicator).
'assertEqualToResult'(Expected, Actual, Result):- eval_args(['assertEqualToResult', Expected, Actual], Result).

% `assertFalse` Predicate
% This predicate is used to assert that the evaluation of EvalThis is false.
% EvalThis: The expression that is being evaluated and checked for falsehood.
% Result: The result of the evaluation.
% Example: `assertFalse((1 > 2), Result).` would succeed, setting Result to true (or some success indicator), as 1 > 2 is false.
'assertFalse'(EvalThis, Result):- eval_args(['assertFalse', EvalThis], Result).

% `assertNotEqual` Predicate
% This predicate asserts that the Expected value is not equal to the Actual value.
% Expected: The value that is expected not to match the Actual value.
% Actual: The value that is being checked against the Expected value.
% Result: The result of the evaluation of the inequality.
% Example: `assertNotEqual(5, 6, Result).` would succeed, setting Result to true (or some success indicator).
'assertNotEqual'(Expected, Actual, Result):- eval_args(['assertNotEqual', Expected, Actual], Result).

% `assertTrue` Predicate
% This predicate is used to assert that the evaluation of EvalThis is true.
% EvalThis: The expression that is being evaluated and checked for truth.
% Result: The result of the evaluation.
% Example: `assertTrue((2 > 1), Result).` would succeed, setting Result to true (or some success indicator), as 2 > 1 is true.
'assertTrue'(EvalThis, Result):- eval_args(['assertTrue', EvalThis], Result).

% `rtrace` Predicate
% This predicate is likely used for debugging; possibly for tracing the evaluation of Condition.
% Condition: The condition/expression being traced.
% EvalResult: The result of the evaluation of Condition.
% Example: `rtrace((2 + 2), EvalResult).` would trace the evaluation of 2 + 2 and store its result in EvalResult.
'rtrace'(Condition, EvalResult):- eval_args(['rtrace', Condition], EvalResult).

% `time` Predicate
% This predicate is used to measure the time taken to evaluate EvalThis.
% EvalThis: The expression whose evaluation time is being measured.
% EvalResult: The result of the evaluation of EvalThis.
% Example: `time((factorial(5)), EvalResult).` would measure the time taken to evaluate factorial(5) and store its result in EvalResult.
'time'(EvalThis, EvalResult):- eval_args(['time', EvalThis], EvalResult).

% ============================
% %%%% Debugging, Printing and Utility Operations
% ============================
% REPL Evaluation
'repl!'(EvalResult):- eval_args(['repl!'], EvalResult).
% Condition Evaluation
'!'(Condition, EvalResult):- eval_args(['!', Condition], EvalResult).
% Import File into Environment
'import!'(Environment, Filename, Namespace):- eval_args(['import!', Environment, Filename], Namespace).
% Evaluate Expression with Pragma
'pragma!'(Environment, Expression, EvalValue):- eval_args(['pragma!', Environment, Expression], EvalValue).
% Print Message to Console
'print'(Message, EvalResult):- eval_args(['print', Message], EvalResult).
% No Operation, Returns EvalResult unchanged
'nop'(Expression, EvalResult):- eval_args(['nop', Expression], EvalResult).

% ============================
% %%%% Variable Bindings
% ============================
% Bind Variables
'bind!'(Environment, Variable, Value):- eval_args(['bind!', Environment, Variable], Value).
% Let binding for single variable
'let'(Variable, Expression, Body, Result):- eval_args(['let', Variable, Expression, Body], Result).
% Sequential let binding
'let*'(Bindings, Body, Result):- eval_args(['let*', Bindings, Body], Result).

% ============================
% %%%% Reflection
% ============================
% Get Type of Value
'get-type'(Value, Type):- eval_args(['get-type', Value], Type).


metta_cmd_args(Rest):- current_prolog_flag(late_metta_opts,Rest),!.
metta_cmd_args(Rest):- current_prolog_flag(argv,P),append(_,['--'|Rest],P),!.
metta_cmd_args(Rest):- current_prolog_flag(os_argv,P),append(_,['--'|Rest],P),!.
metta_cmd_args(Rest):- current_prolog_flag(argv,Rest).
run_cmd_args:- metta_cmd_args(Rest), !,  do_cmdline_load_metta('&self',Rest).

is_metta_data_functor(F):-
  current_self(Self),is_metta_data_functor(Self,F).

is_metta_data_functor(Other,H):-
  metta_type(Other,H,_),
  \+ metta_atom(Other,[H|_]),
  \+ metta_defn(Other,[H|_],_).



metta_make_hook:-  loonit_reset, option_value(not_a_reload,true),!.
metta_make_hook:-
  metta_cmd_args(Rest), into_reload_options(Rest,Reload), cmdline_load_metta('&self',Reload).

:- multifile(prolog:make_hook/2).
:- dynamic(prolog:make_hook/2).
prolog:make_hook(after, _Some):- nop( metta_make_hook).

into_reload_options(Reload,Reload).

is_cmd_option(Opt,M, TF):- atom(M),
   atom_concat('-',Opt,Flag),
   atom_contains(M,Flag),!,
   get_flag_value(M,FV),
   TF=FV.

get_flag_value(M,V):- atomic_list_concat([_,V],'=',M),!.
get_flag_value(M,false):- atom_contains(M,'-no'),!.
get_flag_value(_,true).


:- ignore(((
   \+ prolog_load_context(reloading,true),
   forall(option_value_def(Opt,Default),set_option_value(Opt,Default))))).

%process_option_value_def:- \+ option_value('python',false), skip(ensure_loaded(metta_python)).
process_option_value_def:- option_value('python',load), ensure_loaded(metta_vspace/pyswip/metta_python).
process_option_value_def.


%process_late_opts:- once(option_value('html',true)), once(shell('./total_loonits.sh')).
process_late_opts:- current_prolog_flag(os_argv,[_]),!,ignore(repl).
process_late_opts:- forall(process_option_value_def,true).
%process_late_opts:- halt(7).
process_late_opts.

%do_cmdline_load_metta(_Slf,Rest):- select('--prolog',Rest,RRest),!,
%  set_option_value('prolog',true),
%  set_prolog_flag(late_metta_opts,RRest).
do_cmdline_load_metta(Self,Rest):-
  set_prolog_flag(late_metta_opts,Rest),
  forall(process_option_value_def,true),
  cmdline_load_metta(Self,Rest),!,
  forall(process_late_opts,true).

load_metta_file(Self,Filemask):- atom_concat(_,'.metta',Filemask),!, load_metta(Self,Filemask).
load_metta_file(_Slf,Filemask):- load_flybase(Filemask).

% done
cmdline_load_metta(_,Nil):- Nil==[],!.
cmdline_load_metta(Self,[Filemask|Rest]):- atom(Filemask), \+ atom_concat('-',_,Filemask),
  must_det_ll((Src=load_metta_file(Self,Filemask),nl,write('; '),write_src(Src),nl,catch_red(Src),!,flush_output,
  cmdline_load_metta(Self,Rest))).

cmdline_load_metta(Self,['-g',M|Rest]):-
  read_term_from_atom(M, Term, []),
  ignore(call(Term)),
  cmdline_load_metta(Self,Rest).

cmdline_load_metta(Self,[M|Rest]):-
  m_opt(M,Opt),!,
  is_cmd_option(Opt,M,TF),!,
  format('~N'),write(' ; '), write_src(is_cmd_option(Opt,M,TF)), nl, !, set_option_value(Opt,TF),
  set_tty_color_term(true),
  cmdline_load_metta(Self,Rest).

cmdline_load_metta(Self,[M|Rest]):-
  format('~N'),write('; unused '), write_src(M), nl, !,
  cmdline_load_metta(Self,Rest).


set_tty_color_term(TF):-
  current_output(X),set_stream(X,tty(TF)),
  set_stream(current_output,tty(TF)),
  set_prolog_flag(color_term ,TF).

m_opt(M,Opt):-
  m_opt0(M,Opt1),
  m_opt1(Opt1,Opt).

m_opt1(Opt1,Opt):- atomic_list_concat([Opt|_],'=',Opt1).

m_opt0(M,Opt):- atom_concat('--no-',Opt,M),!.
m_opt0(M,Opt):- atom_concat('--',Opt,M),!.
m_opt0(M,Opt):- atom_concat('-',Opt,M),!.

:- set_prolog_flag(occurs_check,true).

start_html_of(_Filename):- \+ tee_file(_TEE_FILE),!.
start_html_of(_Filename):-
 must_det_ll((
  S = _,
  %retractall(metta_defn(S,_,_)),
  nop(retractall(metta_type(S,_,_))),
  %retractall(metta_atom(S,_,_,_)),
  loonit_reset,
  tee_file(TEE_FILE),
  sformat(S,'cat /dev/null > "~w"',[TEE_FILE]),

  writeln(doing(S)),
  ignore(shell(S)))).

save_html_of(_Filename):- \+ tee_file(_TEE_FILE),!.
save_html_of(_):- \+ has_loonit_results, \+ option_value('html',true).
save_html_of(Filename):-
 must_det_ll((
  file_name_extension(Base,_,Filename),
  file_name_extension(Base,'metta.html',HtmlFilename),
  loonit_reset,
  tee_file(TEE_FILE),
  writeln('<br/><a href="https://github.com/logicmoo/vspace-metta/blob/main/MeTTaLog.md">Return to Summaries</a><br/>'),
  sformat(S,'ansi2html -u < "~w" > "~w" ',[TEE_FILE,HtmlFilename]),
  writeln(doing(S)),
  ignore(shell(S)))).

tee_file(TEE_FILE):- getenv('TEE_FILE',TEE_FILE),!.
tee_file(TEE_FILE):- metta_dir(Dir),directory_file_path(Dir,'TEE.ansi',TEE_FILE),!.
metta_dir(Dir):- getenv('METTA_DIR',Dir),!.

load_metta(Filename):-
 %clear_spaces,
 load_metta('&self',Filename).


load_metta(Self,RelFilename):-
 atom(RelFilename),
 exists_file(RelFilename),!,
 absolute_file_name(RelFilename,Filename),
 track_load_into_file(Filename,
   include_metta(Self,RelFilename)).
load_metta(_Self,Filename):- Filename=='--repl',!,repl.
load_metta(Self,Filename):-
  (\+ atom(Filename); \+ exists_file(Filename)),!,
  with_wild_path(load_metta(Self),Filename),!,loonit_report.

include_metta(Self,Filename):-
  (\+ atom(Filename); \+ exists_file(Filename)),!,
  must_det_ll(with_wild_path(include_metta(Self),Filename)),!.

include_metta(Self,RelFilename):-
 must_det_ll((
  atom(RelFilename),
  exists_file(RelFilename),!,
  absolute_file_name(RelFilename,Filename),
   must_det_ll((setup_call_cleanup(open(Filename,read,In, [encoding(utf8)]),
    ((directory_file_path(Directory, _, Filename),
      assert(metta_file(Self,Filename,Directory)),
      with_cwd(Directory,
        must_det_ll( load_metta_file_stream(Filename,Self,In))))),close(In)))))).

load_metta_file_stream(Filename,Self,In):-
  with_option(loading_file,Filename,
   %current_exec_file(Filename),
   ((must_det_ll((
       set_exec_num(Filename,1),
       load_answer_file(Filename),
       set_exec_num(Filename,0))),
     ((repeat,
        must_det_ll((
          ((nb_current(read_mode,Mode),Mode\==[])->true;Mode=load),
            once(read_metta(In,Expr)), %write_src(read_metta=Expr),nl,
            once((do_metta(file(Filename),Mode,Self,Expr,_O)->true;
                 pp_m(unknown_do_metta(file(Filename),Mode,Self,Expr)))),
           flush_output)),
          at_end_of_stream(In)))))),!.


clear_spaces:- clear_space(_).
clear_space(S):-
   retractall(metta_defn(S,_,_)),
   nop(retractall(metta_type(S,_,_))),
   retractall(metta_atom(S,_)).

metta_type(S,H,B):- metta_atom(S,[':',H,B]).

lsm:- lsm(_).
lsm(S):-
   listing(metta_file(S,_,_)),
   %listing(mdyn_type(S,_,_,_)),
   forall(mdyn_type(S,_,_,Src),color_g_mesg('#22a5ff',write_f_src(Src))),
   nl,nl,nl,
   forall(mdyn_defn(S,_,_,Src),color_g_mesg('#00ffa5',write_f_src(Src))),
   %listing(mdyn_defn(S,_,_,_)),
   !.

write_f_src(H,B):- H=@=B,!,write_f_src(H).
write_f_src(H,B):- write_f_src(['=',H,B]).

hb_f(HB,ST):- sub_term(ST,HB),(atom(ST),ST\==(=),ST\==(:)),!.
write_f_src(HB):-
  hb_f(HB,ST),
  option_else(current_def,CST,[]),!,
  (CST == ST -> true ; (nl,nl,nl,set_option_value(current_def,ST))),
  write_src(HB).



debug_only(G):- notrace(ignore(catch_warn(G))).
debug_only(_What,G):- ignore((fail,notrace(catch_warn(G)))).


'True':- true.
'False':- fail.


'metta_learner::vspace-main':- repl.

into_underscores(D,U):- atom(D),!,atomic_list_concat(L,'-',D),atomic_list_concat(L,'_',U).
into_underscores(D,U):- descend_and_transform(into_underscores,D,U),!.

into_hyphens(D,U):- atom(D),!,atomic_list_concat(L,'_',D),atomic_list_concat(L,'-',U).
into_hyphens(D,U):- descend_and_transform(into_hyphens,D,U),!.

descend_and_transform(P2, Input, Transformed) :-
    (   var(Input)
    ->  Transformed = Input  % Keep variables as they are
    ;   compound(Input)
    -> (compound_name_arguments(Input, Functor, Args),
        maplist(descend_and_transform(P2), Args, TransformedArgs),
        compound_name_arguments(Transformed, Functor, TransformedArgs))
    ;   (atom(Input),call(P2,Input,Transformed))
    ->  true % Transform atoms using xform_atom/2
    ;   Transformed = Input  % Keep other non-compound terms as they are
    ).

is_syspred(H,Len,Pred):- notrace(is_syspred0(H,Len,Pred)).
is_syspred0(H,_Ln,_Prd):- \+ atom(H),!,fail.
is_syspred0(H,_Ln,_Prd):- upcase_atom(H,U),downcase_atom(H,U),!,fail.
is_syspred0(H,Len,Pred):- current_predicate(H/Len),!,Pred=H.
is_syspred0(H,Len,Pred):- atom_concat(Mid,'!',H), H\==Mid, is_syspred0(Mid,Len,Pred),!.
is_syspred0(H,Len,Pred):- into_underscores(H,Mid), H\==Mid, is_syspred0(Mid,Len,Pred),!.

fn_append(List,X,Call):-
  fn_append1(List,X,ListX),
  into_fp(ListX,Call).

is_function(F):- atom(F).

is_False(X):- X\=='True', (is_False1(X)-> true ; (eval_args(X,Y),is_False1(Y))).
is_False1(Y):- (Y==0;Y==[];Y=='False').

is_conz(Self):- compound(Self), Self=[_|_].

%dont_x(eval_args(Depth,Self,metta_if(A<B,L1,L2),R)).
dont_x(eval_args(_<_,_)).

into_fp(D,D):- \+ \+ dont_x(D),!.
into_fp(ListX,CallAB):-
  sub_term(STerm,ListX),needs_expanded(STerm,Term),
  %copy_term(Term,CTerm),
  =(Term,CTerm),
  substM(ListX,CTerm,Var,CallB), fn_append1(Term,Var,CallA),
  into_fp((CallA,CallB),CallAB).
into_fp(A,A).

needs_expand(Expand):- compound(Expand),functor(Expand,F,N),N>=1,atom_concat(metta_,_,F).
needs_expanded(eval_args(Term,_),Expand):- !,sub_term(Expand,Term),compound(Expand),Expand\=@=Term,
   compound(Expand), \+ is_conz(Expand), \+ is_ftVar(Expand), needs_expand(Expand).
needs_expanded([A|B],Expand):- sub_term(Expand,[A|B]), compound(Expand), \+ is_conz(Expand), \+ is_ftVar(Expand), needs_expand(Expand).

fn_append1(eval_args(Term,X),X,eval_args(Term,X)):-!.
fn_append1(Term,X,eval_args(Term,X)).


% Check if parentheses are balanced in a list of characters
balanced_parentheses(Chars) :- balanced_parentheses(Chars, 0).
balanced_parentheses([], 0).
balanced_parentheses(['('|T], N) :- N1 is N + 1, balanced_parentheses(T, N1).
balanced_parentheses([')'|T], N) :- N > 0, N1 is N - 1, balanced_parentheses(T, N1).
balanced_parentheses([H|T], N) :- H \= '(', H \= ')', balanced_parentheses(T, N).
% Recursive function to read lines until parentheses are balanced.
repl_read(NewAccumulated, Expr):-
    atom_concat(Atom, '.', NewAccumulated),
    catch((read_term_from_atom(Atom, Term, []), Expr=call(Term)), E,
       (write('Syntax error: '), writeq(E), nl, repl_read(Expr))),!.


repl_read("!", '!'):-!.
repl_read("+", '+'):-!.
repl_read(Str,Atom):- atom_string(Atom,Str),metta_interp_mode(Atom,_),!.

repl_read(Str, Expr):- atom_concat('@',_,Str),!,atom_string(Expr,Str).
repl_read(NewAccumulated, Expr):-
    normalize_space(string(Renew),NewAccumulated), Renew \== NewAccumulated, !,
    repl_read(Renew, Expr).
repl_read(NewAccumulated,exec(Expr)):- string_concat("!",Renew,NewAccumulated), !,
    repl_read(Renew, Expr).
repl_read(NewAccumulated, Expr):- string_chars(NewAccumulated, Chars),
    balanced_parentheses(Chars), length(Chars, Len), Len > 0, parse_sexpr_metta(NewAccumulated, Expr), !.
repl_read(Accumulated, Expr) :- read_line_to_string(current_input, Line), repl_read(Accumulated, Line, Expr).
repl_read(Accumulated, "", Expr):- !, repl_read(Accumulated, Expr).
repl_read(_Accumulated, Line, Expr):- Line == end_of_file, !, Expr = Line.
repl_read(Accumulated, Line, Expr) :- atomics_to_string([Accumulated," ",Line], NewAccumulated), !,
    repl_read(NewAccumulated, Expr).

repl_read(O2):- clause(t_l:s_reader_info(O2),_,Ref),erase(Ref).
repl_read(Expr) :- repeat,
  remove_pending_buffer_codes(_,Was),text_to_string(Was,Str),
      repl_read(Str, Expr1),
        once(((atom(Expr1),atom_concat('@',_,Expr1),
            \+ atom_contains(Expr1,"="),
            repl_read(Expr2))
            -> Expr=[Expr1,Expr2] ; Expr1 = Expr)),
        % this cutrs the repeat/0
        ((peek_pending_codes(_,Peek),Peek==[])->!;true).

add_history_string(Str):- notrace(ignore(add_history01(Str))),!.

add_history_src(Exec):- notrace(ignore((Exec\=[],with_output_to(string(H),with_indents(false,write_src(Exec))),add_history_string(H)))).

read_metta1(_,O2):- clause(t_l:s_reader_info(O2),_,Ref),erase(Ref).
read_metta1(In,Expr):- current_input(In0),In==In0,!, repl_read(Expr).
read_metta1(In,Expr):- string(In),!,parse_sexpr_metta(In,Expr),!.
read_metta1(In,Expr):- peek_char(In,Char), read_metta1(In,Char,Expr).

read_metta1(In,Char,Expr):- char_type(Char,white),get_char(In,Char),put(Char),!,read_metta1(In,Expr).
read_metta1(In,'!',Expr):- get_char(In,_), !, read_metta(In,Read1),!,Expr=exec(Read1).
read_metta1(In,';',Expr):- get_char(In,_), !, (maybe_read_pl(In,Expr)-> true ; (read_line_to_string(In,Str),write_comment(Str),!,read_metta(In,Expr))),!.
read_metta1(In,_,Expr):-  maybe_read_pl(In,Expr),!.
read_metta1(In,_,Read1):- parse_sexpr_metta(In,Expr),!,must_det_ll(Expr=Read1).


maybe_read_pl(In,Expr):-
  peek_line(In,Line1), Line1\=='', atom_contains(Line1, '.'),atom_contains(Line1, ':-'),
  notrace(((catch((read_term_from_atom(Line1, Term, []), Term\==end_of_file, Expr=call(Term)),_, fail),!,
  read_term(In, Term, [])))).
peek_line(In,Line1):- peek_string(In, 1024, Str), split_string(Str, "\r\n", "\s", [Line1,_|_]),!.
peek_line(In,Line1):- peek_string(In, 4096, Str), split_string(Str, "\r\n", "\s", [Line1,_|_]),!.




%read_line_to_sexpr(Stream,UnTyped),
read_sform(Str,F):- trace, string(Str),open_string(Str,S),!,read_sform(S,F).
read_sform(S,F):-
  read_sform1(S,F1),
  ( F1\=='!' -> F=F1 ;
    (read_sform1(S,F2), F = exec(F2))).

read_sform1(Str,F):- string(Str),open_string(Str,S),!,read_sform1(S,F).
read_sform1(S,F):- at_end_of_stream(S),!,F=end_of_file.
read_sform1(S,M):- peek_char(S,C),read_sform3(C,S,F), untyped_to_metta(F,M).
%read_sform1(S,F):- profile(parse_sexpr_metta(S,F)).

read_sform3(C,S,F):- char_type(C,white),get_char(S,_),!,read_sform1(S,F).
read_sform3(';',S,'$COMMENT'(F,0,0)):- !, read_line_to_string(S,F).
read_sform3(';',S,F):- read_line_to_string(S,_),!,read_sform1(S,F).
read_sform3('!',S,exec(F)):- !,get_char(S,_),read_sform1(S,F).
read_sform3(_,S,F):- read_line_to_string(S,L),!,read_sform_cont(L,S,F).

read_sform_cont(L,S,F):- L=="", !, read_sform1(S,F).
read_sform_cont(L,_S,F):- input_to_forms(L,F),!.
read_sform_cont(L,S,F):- read_line_to_string(S,L2),
  atomic_to_string([L,' ',L2],L3),read_sform_cont(L3,S,F),!.

in2_stream(N1,S1):- integer(N1),!,stream_property(S1,file_no(N1)),!.
in2_stream(N1,S1):- atom(N1),stream_property(S1,alias(N1)),!.
in2_stream(N1,S1):- is_stream(N1),S1=N1,!.
in2_stream(N1,S1):- atom(N1),stream_property(S1,file_name(N1)),!.
is_same_streams(N1,N2):- in2_stream(N1,S1),in2_stream(N2,S2),!,S1==S2.

%read_metta(In,Expr):- current_input(CI), \+ is_same_streams(CI,In), !, read_sform(In,Expr).
read_metta(_,O2):- clause(t_l:s_reader_info(O2),_,Ref),erase(Ref).
read_metta(In,Expr):- current_input(In0),In==In0,!, repl_read(Expr).
read_metta(In,Expr):-
 read_metta1(In,Read1),
  (Read1=='!'
     -> (read_metta1(In,Read2), Expr=exec(Read2), add_history_src(Expr))
     ; Expr = Read1),!.

parse_sexpr_metta(I,O):- string(I),normalize_space(string(M),I),parse_sexpr_metta1(M,O),!.
parse_sexpr_metta(I,O):- parse_sexpr_untyped(I,U),trly(untyped_to_metta,U,O).

parse_sexpr_metta1(M,exec(O)):- string_concat('!',I,M),!,parse_sexpr_metta1(I,O).
parse_sexpr_metta1(M,(O)):- string_concat('+',I,M),!,parse_sexpr_metta1(I,O).
parse_sexpr_metta1(I,O):- parse_sexpr_untyped(I,U),trly(untyped_to_metta,U,O).

mlog_sym('@').

%untyped_to_metta(I,exec(O)):- compound(I),I=exec(M),!,untyped_to_metta(M,O).
untyped_to_metta(I,O):-
 must_det_ll((
  trly(mfix_vars1,I,M),
  trly(cons_to_c,M,OM),
  trly(cons_to_l,OM,O))).


trly(P2,A,B):- once(call(P2,A,M)),A\=@=M,!,trly(P2,M,B).
trly(_,A,A).

mfix_vars1(I,O):- var(I),!,I=O.
mfix_vars1('$t','$VAR'('T')):-!.
mfix_vars1('$T','$VAR'('T')):-!.
%mfix_vars1(I,O):- I=='T',!,O='True'.
%mfix_vars1(I,O):- I=='F',!,O='False'.
%mfix_vars1(I,O):- is_i_nil(I),!,O=[].
mfix_vars1(I,O):- I=='true',!,O='True'.
mfix_vars1(I,O):- I=='false',!,O='False'.
mfix_vars1('$STRING'(I),O):- option_value(strings,true),!, mfix_vars1(I,O).
mfix_vars1('$STRING'(I),O):- !, mfix_vars1(I,M),atom_chars(O,M),!.
%mfix_vars1('$STRING'(I),O):- !, mfix_vars1(I,M),name(O,M),!.
mfix_vars1([H|T],O):-   H=='[', is_list(T), last(T,L),L==']',append(List,[L],T), !, O = ['[...]',List].
mfix_vars1([H|T],O):-   H=='{', is_list(T), last(T,L),L=='}',append(List,[L],T), !, O = ['{...}',List].
mfix_vars1('$OBJ'(claz_bracket_vector,List),O):- is_list(List),!, O = ['[...]',List].
mfix_vars1(I,O):-  I = ['[', X, ']'], nonvar(X), !, O = ['[...]',X].
mfix_vars1(I,O):-  I = ['{', X, '}'], nonvar(X), !, O = ['{...}',X].
mfix_vars1('$OBJ'(claz_bracket_vector,List),Res):- is_list(List),!, append(['['|List],[']'],Res),!.
mfix_vars1(I,O):- I==[Quote, S], Quote==quote,S==s,!, O=is.
mfix_vars1([K,H|T],Cmpd):- atom(K),mlog_sym(K),is_list(T),mfix_vars1([H|T],[HH|TT]),atom(HH),is_list(TT),!,
  compound_name_arguments(Cmpd,HH,TT).
%mfix_vars1([H|T],[HH|TT]):- !, mfix_vars1(H,HH),mfix_vars1(T,TT).
mfix_vars1(List,ListO):- is_list(List),!,maplist(mfix_vars1,List,ListO).
mfix_vars1(I,O):- string(I),option_value('string-are-atoms',true),!,atom_string(O,I).

mfix_vars1(I,O):- compound(I),!,compound_name_arguments(I,F,II),F\=='$VAR',maplist(mfix_vars1,II,OO),!,compound_name_arguments(O,F,OO).
mfix_vars1(I,O):- \+ atom(I),!,I=O.
mfix_vars1(I,'$VAR'(O)):- atom_concat('$',N,I),dvar_name(N,O),!.
mfix_vars1(I,I).

no_cons_reduce.

dvar_name(t,'T'):- !.
dvar_name(N,O):- atom(N),atom_number(N,Num),atom_concat('Num',Num,M),!,svar_fixvarname(M,O).
dvar_name(N,O):- number(N),atom_concat('Num',N,M),!,svar_fixvarname(M,O).
dvar_name(N,O):- \+ atom(N),!,format(atom(A),'~w',[N]),dvar_name(A,O).
dvar_name('','__'):-!. % "$"
dvar_name('_','_'):-!. % "$_"
dvar_name(N,O):- svar_fixvarname(N,O),!.
dvar_name(N,O):- must_det_ll((atom_chars(N,Lst),maplist(c2vn,Lst,NList),atomic_list_concat(NList,S),svar_fixvarname(S,O))),!.
c2vn(A,A):- char_type(A,prolog_identifier_continue),!.
c2vn(A,A):- char_type(A,prolog_var_start),!.
c2vn(A,AA):- char_code(A,C),atomic_list_concat(['_C',C,'_'],AA).

cons_to_l(I,I):- no_cons_reduce,!.
cons_to_l(I,O):- var(I),!,O=I.
cons_to_l(I,O):- is_i_nil(I),!,O=[].
cons_to_l(I,O):- I=='nil',!,O=[].
cons_to_l(C,O):- \+ compound(C),!,O=C.
cons_to_l([Cons,H,T|List],[HH|TT]):- List==[], atom(Cons),is_cons_f(Cons), t_is_ttable(T), cons_to_l(H,HH),!,cons_to_l(T,TT).
cons_to_l(List,ListO):- is_list(List),!,maplist(cons_to_l,List,ListO).
cons_to_l(I,I).

cons_to_c(I,I):- no_cons_reduce,!.
cons_to_c(I,O):- var(I),!,O=I.
cons_to_c(I,O):- is_i_nil(I),!,O=[].
cons_to_c(I,O):- I=='nil',!,O=[].
cons_to_c(C,O):- \+ compound(C),!,O=C.
cons_to_c([Cons,H,T|List],[HH|TT]):- List==[], atom(Cons),is_cons_f(Cons), t_is_ttable(T), cons_to_c(H,HH),!,cons_to_c(T,TT).
cons_to_c(I,O):- \+ is_list(I), compound_name_arguments(I,F,II),maplist(cons_to_c,II,OO),!,compound_name_arguments(O,F,OO).
cons_to_c(I,I).



t_is_ttable(T):- var(T),!.
t_is_ttable(T):- is_i_nil(T),!.
t_is_ttable(T):- is_ftVar(T),!.
t_is_ttable([F|Args]):- F=='Cons',!,is_list(Args).
t_is_ttable([_|Args]):- !, \+ is_list(Args).
t_is_ttable(_).

is_cons_f(Cons):- is_cf_nil(Cons,_).
is_cf_nil('Cons','NNNil').
%is_cf_nil('::','nil').

is_i_nil(I):-
  is_cf_nil('Cons',Nil), I == Nil.

subst_vars(TermWDV, NewTerm):-
   subst_vars(TermWDV, NewTerm, NamedVarsList),
   maybe_set_var_names(NamedVarsList).

subst_vars(TermWDV, NewTerm, NamedVarsList) :-
    subst_vars(TermWDV, NewTerm, [], NamedVarsList).

subst_vars(Term, Term, NamedVarsList, NamedVarsList) :- var(Term), !.
subst_vars([], [], NamedVarsList, NamedVarsList):- !.
subst_vars([TermWDV|RestWDV], [Term|Rest], Acc, NamedVarsList) :- !,
    subst_vars(TermWDV, Term, Acc, IntermediateNamedVarsList),
    subst_vars(RestWDV, Rest, IntermediateNamedVarsList, NamedVarsList).
subst_vars('$VAR'('_'), _, NamedVarsList, NamedVarsList) :- !.
subst_vars('$VAR'(VName), Var, Acc, NamedVarsList) :- nonvar(VName), svar_fixvarname(VName,Name), !,
    (memberchk(Name=Var, Acc) -> NamedVarsList = Acc ; ( !, Var = _, NamedVarsList = [Name=Var|Acc])).
subst_vars(Term, Var, Acc, NamedVarsList) :- atom(Term),atom_concat('$',DName,Term),
   dvar_name(DName,Name),!,subst_vars('$VAR'(Name), Var, Acc, NamedVarsList).

subst_vars(TermWDV, NewTerm, Acc, NamedVarsList) :-
    compound(TermWDV), !,
    compound_name_arguments(TermWDV, Functor, ArgsWDV),
    subst_vars(ArgsWDV, Args, Acc, NamedVarsList),
    compound_name_arguments(NewTerm, Functor, Args).
subst_vars(Term, Term, NamedVarsList, NamedVarsList).



:- nb_setval(variable_names,[]).


assert_preds(_Self,_Load,_Preds):- \+ preview_compiler,!.
assert_preds(_Self,Load,Preds):-
  expand_to_hb(Preds,H,_B),functor(H,F,A),
  color_g_mesg('#005288',(
   ignore((
    \+ predicate_property(H,defined),
    if_t(use_metta_compiler,catch_i(dynamic(F,A))),
    format('  :- ~q.~n',[dynamic(F/A)]),
    if_t(option_value('tabling',true), format('  :- ~q.~n',[table(F/A)])))),
   if_t((preview_compiler),
     format('~N~n  ~@',[portray_clause(Preds)])),
   if_t(use_metta_compiler,if_t(\+ predicate_property(H,static),add_assertion(Preds))))),
   nop(metta_anew1(Load,Preds)).


%load_hook(_Load,_Hooked):- !.
load_hook(Load,Hooked):- ignore(( \+ ((forall(load_hook0(Load,Hooked),true))))),!.

load_hook0(_,_):- \+ current_prolog_flag(metta_interp,ready),!.
load_hook0(_,_):- \+ preview_compiler,!.
load_hook0(Load,metta_defn(Self,H,B)):-
       functs_to_preds([=,H,B],Preds),
       assert_preds(Self,Load,Preds).
/*
load_hook0(Load,metta_atom(Self,H)):- B = 'True',
       H\=[':'|_], functs_to_preds([=,H,B],Preds),
       assert_preds(Self,Load,Preds).
*/

use_metta_compiler:- notrace(option_value('compile','full')), !.
preview_compiler:- \+ option_value('compile',false), !.
%preview_compiler:- use_metta_compiler,!.



op_decl(match, [ 'Space', 'Atom', 'Atom'], '%Undefined%').
op_decl('remove-atom', [ 'Space', 'Atom'], 'EmptyType').
op_decl('add-atom', [ 'Space', 'Atom'], 'EmptyType').
op_decl('get-atoms', [ 'Space' ], 'Atom').

op_decl('car-atom', [ 'Expression' ], 'Atom').
op_decl('cdr-atom', [ 'Expression' ], 'Expression').

op_decl(let, [ 'Atom', '%Undefined%', 'Atom' ], 'Atom').
op_decl('let*', [ 'Expression', 'Atom' ], 'Atom').

op_decl(and, [ 'Bool', 'Bool' ], 'Bool').
op_decl(or, [ 'Bool', 'Bool' ], 'Bool').
op_decl(case, [ 'Expression', 'Atom' ], 'Atom').
/*
op_decl(apply, [ 'Atom', 'Variable', 'Atom' ], 'Atom').
op_decl(chain, [ 'Atom', 'Variable', 'Atom' ], 'Atom').
op_decl('filter-atom', [ 'Expression', 'Variable', 'Atom' ], 'Expression').
op_decl('foldl-atom', [ 'Expression', 'Atom', 'Variable', 'Variable', 'Atom' ], 'Atom').
op_decl('map-atom', [ 'Expression', 'Variable', 'Atom' ], 'Expression').
op_decl(quote, [ 'Atom' ], 'Atom').
op_decl('if-decons', [ 'Atom', 'Variable', 'Variable', 'Atom', 'Atom' ], 'Atom').
op_decl('if-empty', [ 'Atom', 'Atom', 'Atom' ], 'Atom').
op_decl('if-error', [ 'Atom', 'Atom', 'Atom' ], 'Atom').
op_decl('if-non-empty-expression', [ 'Atom', 'Atom', 'Atom' ], 'Atom').
op_decl('if-not-reducible', [ 'Atom', 'Atom', 'Atom' ], 'Atom').
op_decl(return, [ 'Atom' ], 'ReturnType').
op_decl('return-on-error', [ 'Atom', 'Atom'], 'Atom').
op_decl(unquote, [ '%Undefined%'], '%Undefined%').
op_decl(cons, [ 'Atom', 'Atom' ], 'Atom').
op_decl(decons, [ 'Atom' ], 'Atom').
op_decl(empty, [], '%Undefined%').
op_decl('Error', [ 'Atom', 'Atom' ], 'ErrorType').
op_decl(eval, [ 'Atom' ], 'Atom').
op_decl(function, [ 'Atom' ], 'Atom').
op_decl(id, [ 'Atom' ], 'Atom').
op_decl(unify, [ 'Atom', 'Atom', 'Atom', 'Atom' ], 'Atom').
*/
op_decl(unify, [ 'Atom', 'Atom', 'Atom', 'Atom'], '%Undefined%').
op_decl(if, [ 'Bool', 'Atom', 'Atom'], _T).
op_decl('%', [ 'Number', 'Number' ], 'Number').
op_decl('*', [ 'Number', 'Number' ], 'Number').
op_decl('-', [ 'Number', 'Number' ], 'Number').
op_decl('+', [ 'Number', 'Number' ], 'Number').
op_decl(combine, [ X, X], X).

op_decl('bind!', ['Symbol','%Undefined%'], 'EmptyType').
op_decl('import!', ['Space','Atom'], 'EmptyType').
op_decl('get-type', ['Atom'], 'Atom').

type_decl('Any').
type_decl('Atom').
type_decl('Bool').
type_decl('ErrorType').
type_decl('Expression').
type_decl('Number').
type_decl('ReturnType').
type_decl('Space').
type_decl('Symbol').
type_decl('MemoizedState').
type_decl('Type').
type_decl('%Undefined%').
type_decl('Variable').

:- dynamic(metta_atom/2).
metta_atom('&stdlib', [:, Type, 'Type']):- type_decl(Type).
metta_atom('&stdlib', [:, Op, [->|List]]):- op_decl(Op,Params,ReturnType),append(Params,[ReturnType],List).
metta_atom(KB,Atom):- KB \= '&stdlib', metta_atom('&stdlib',Atom).
metta_atom(KB, [F, A| List]):- nonvar(F), KB=='&flybase',fb_pred(F, Len), length([A|List],Len),apply(F,[A|List]).
metta_atom(Space, Atom):- typed_list(Space,_,L),!, member(Atom,L).

%atom1_atom_4(Space,F,A,List):- nonvar(Space), metta_atom(Space, F, A, List).




%metta_atom(KB, [F|List]):- KB=='&flybase',fb_pred(F, Len), length(List,Len),apply(F,List).
%metta_atom(KB,[F,A|List]):- metta_atom(KB,F,A,List), F \== '=',!.
metta_defn(KB,Head,Body):- metta_atom(KB,['=',Head,Body]).

%maybe_xform(metta_atom(KB,[F,A|List]),metta_atom(KB,F,A,List)):- is_list(List),!.
maybe_xform(metta_defn(KB,Head,Body),metta_atom(KB,['=',Head,Body])).
maybe_xform(metta_type(KB,Head,Body),metta_atom(KB,[':',Head,Body])).
maybe_xform(_OBO,_XForm):- !, fail.

metta_anew1(Load,_OBO):- var(Load),trace,!.
metta_anew1(Load,OBO):- maybe_xform(OBO,XForm),!,metta_anew1(Load,XForm).


metta_anew1(load,OBO):- OBO= metta_atom(Space,Atom),!,'add-atom'(Space, Atom).
metta_anew1(unload,OBO):- OBO= metta_atom(Space,Atom),!,'remove-atom'(Space, Atom).

metta_anew1(load,OBO):- must_det_ll((load_hook(load,OBO),subst_vars(OBO,Cl),assertz_if_new(Cl))). %to_metta(Cl).
metta_anew1(unload,OBO):- subst_vars(OBO,Cl),load_hook(unload,OBO),
  expand_to_hb(Cl,Head,Body),
  predicate_property(Head,number_of_clauses(_)),
  ignore((clause(Head,Body,Ref),clause(Head2,Body2,Ref),(Head+Body)=@=(Head2+Body2),erase(Ref),pp_m(Cl))).

metta_anew2(Load,_OBO):- var(Load),trace,!.
metta_anew2(Load,OBO):- maybe_xform(OBO,XForm),!,metta_anew2(Load,XForm).
metta_anew2(load,OBO):- must_det_ll((load_hook(load,OBO),subst_vars_not_last(OBO,Cl),assertz_if_new(Cl))). %to_metta(Cl).
metta_anew2(unload,OBO):- subst_vars_not_last(OBO,Cl),load_hook(unload,OBO),
  expand_to_hb(Cl,Head,Body),
  predicate_property(Head,number_of_clauses(_)),
  ignore((clause(Head,Body,Ref),clause(Head2,Body2,Ref),(Head+Body)=@=(Head2+Body2),erase(Ref),pp_m(Cl))).


metta_anew(Load,_Src,OBO):- silent_loading,!,metta_anew1(Load,OBO).
metta_anew(Load,Src,OBO):- maybe_xform(OBO,XForm),!,metta_anew(Load,Src,XForm).
metta_anew(Load,Src,OBO):- format('~N'), color_g_mesg('#0f0f0f',(write('  ; Action: '),writeq(Load=OBO))),
   color_g_mesg('#ffa500', write_src(Src)),metta_anew1(Load,OBO),format('~n').

subst_vars_not_last(A,B):-
  functor(A,_F,N),arg(N,A,E),
  subst_vars(A,B),
  nb_setarg(N,B,E),!.

con_write(W):-check_silent_loading, write(W).
con_writeq(W):-check_silent_loading, writeq(W).
writeqln(Q):- check_silent_loading,write(' '),con_writeq(Q),connl.

connlf:- check_silent_loading, format('~N').
connl:- check_silent_loading,nl.
% check_silent_loading:- silent_loading,!,trace,break.
check_silent_loading.
silent_loading:- is_converting,!.
silent_loading:- \+ option_value('trace-on-load',true), !.



uncompound(OBO,Src):- \+ compound(OBO),!, Src = OBO.
uncompound('$VAR'(OBO),'$VAR'(OBO)):-!.
uncompound(IsList,Src):- is_list(IsList),!,maplist(uncompound,IsList,Src).
uncompound([Is|NotList],[SrcH|SrcT]):-!, uncompound(Is,SrcH),uncompound(NotList,SrcT).
uncompound(Compound,Src):- compound_name_arguments(Compound,Name,Args),maplist(uncompound,[Name|Args],Src).

:- dynamic(all_data_to/1).
all_data_once:- all_data_to(_),!.
all_data_once:- open(all_data,write,Out,[alias(all_data),encoding(utf8),lock(write)]),
  assert(all_data_to(Out)),
  writeln(Out,':- encoding(utf8).'),
  writeln(Out,':- style_check(-discontiguous).'),
  all_data_preds.

all_data_preds:-
 all_data_to(Out),
 with_output_to(Out,
((listing(table_n_type/3),
  listing(load_state/2),
  listing(is_loaded_from_file_count/2),
  listing(fb_pred/2),
  listing(fb_arg_type/1),
  listing(fb_arg_table_n/3),
  listing(fb_arg/1),
  listing(done_reading/1)))),!.

all_data_done:-
  all_data_preds,
  retract(all_data_to(Out)),
  close(Out).



%real_assert(OBO):- is_converting,!,print_src(OBO).
real_assert(OBO):- all_data_to(Out),!,write_canonical(Out,OBO),!,writeln(Out,'.').
real_assert(OBO):- call(OBO),!.
real_assert(OBO):- assert(OBO),
  (is_converting->print_src(OBO);true).

print_src(OBO):- format('~N'), uncompound(OBO,Src),!, write_src(Src).

assert_to_metta(_):- reached_file_max,!.
assert_to_metta(OBO):- !, functor(OBO,Fn,A),decl_fb_pred(Fn,A), !,real_assert(OBO),!,
   incr_file_count(_),heartbeat.

assert_to_metta(OBO):-
 ignore(( A>=2,A<700,
  OBO=..[Fn|Cols],
 must_det_ll((
  make_assertion4(Fn,Cols,Data,OldData),
  functor(Data,FF,AA),
  decl_fb_pred(FF,AA),
  ((fail,call(Data))->true;(
   must_det_ll((
     real_assert(Data),
     incr_file_count(_),
     ignore((((should_show_data(X),
       ignore((fail,OldData\==Data,write('; oldData '),write_src(OldData),format('  ; ~w ~n',[X]))),
       write_src(Data),format('  ; ~w ~n',[X]))))),
     ignore((
       fail, option_value(output_stream,OutputStream),
       is_stream(OutputStream),
       should_show_data(X1),X1<1000,must_det_ll((display(OutputStream,Data),writeln(OutputStream,'.'))))))))))))),!.

assert_MeTTa(OBO):- !, assert_to_metta(OBO).
%assert_MeTTa(OBO):- !, assert_to_metta(OBO),!,heartbeat.
/*
assert_MeTTa(Data):- !, heartbeat, functor(Data,F,A), A>=2,
   decl_fb_pred(F,A),
   incr_file_count(_),
   ignore((((should_show_data(X),
       write(newData(X)),write(=),write_src(Data))))),
   assert(Data),!.
*/


:- dynamic((metta_type/3,metta_defn/3,metta_atom/2)).

into_space(Self,'&self',Self):-!.
into_space(_,Other,Other):-!.


into_space(Self,Myself,SelfO):- into_space(30,Self,Myself,SelfO).

into_space(_Dpth,Self,Myself,Self):-Myself=='&self',!.
into_space(_Dpth,Self,None,Self):- 'None' == None,!.
into_space(Depth,Self,Other,Result):- eval_args(Depth,Self,Other,Result).
into_name(_,Other,Other).

%eval_f_args(Depth,Self,F,ARGS,[F|EARGS]):- maplist(eval_args(Depth,Self),ARGS,EARGS).


combine_result(TF,R2,R2):- TF == [], !.
combine_result(TF,_,TF):-!.


do_metta1_e(_Self,_,exec(Exec)):- !,write_exec(Exec),!.
do_metta1_e(_Self,_,[=,A,B]):- !, with_concepts(false,
  (con_write('(= '), with_indents(false,write_src(A)), (is_list(B) -> connl ; true),con_write(' '),with_indents(true,write_src(B)),con_write(')'))),connl.
do_metta1_e(_Self,_LoadExec,Term):- write_src(Term),connl.

write_exec(Exec):- notrace(write_exec0(Exec)).
%write_exec0(Exec):- atom(Exec),!,write_exec0([Exec]).
write_exec0(Exec):-
  wots(S,write_src(exec(Exec))),
  nb_setval(exec_src,Exec),
  ignore((notrace((color_g_mesg_ok('#0D6328',(format('~N'),writeln(S))))))).




asserted_do_metta(Space,Load,Src):- asserted_do_metta2(Space,Load,Src,Src).

asserted_do_metta2(Self,Load,[TypeOp,Fn,Type], Src):- TypeOp = ':', \+ is_list(Type),!,
 must_det_ll((
  color_g_mesg_ok('#ffa500',metta_anew(Load,Src,metta_atom(Self,[':',Fn,Type]))))),!.

asserted_do_metta2(Self,Load,[TypeOp,Fn,TypeDecL], Src):- TypeOp = ':',!,
 must_det_ll((
  decl_length(TypeDecL,Len),LenM1 is Len - 1, last_element(TypeDecL,LE),
  color_g_mesg_ok('#ffa500',metta_anew(Load,Src,metta_atom(Self,[':',Fn,TypeDecL]))),
  metta_anew1(Load,metta_arity(Self,Fn,LenM1)),
  arg_types(TypeDecL,[],EachArg),
  metta_anew1(Load,metta_params(Self,Fn,EachArg)),!,
  metta_anew1(Load,metta_last(Self,Fn,LE)))).

asserted_do_metta2(Self,Load,[TypeOp,Fn,TypeDecL,RetType], Src):- TypeOp = ':',!,
 must_det_ll((
  decl_length(TypeDecL,Len),
  append(TypeDecL,[RetType],TypeDecLRet),
  color_g_mesg_ok('#ffa500',metta_anew(Load,Src,metta_atom(Self,[':',Fn,TypeDecLRet]))),
  metta_anew1(Load,metta_arity(Self,Fn,Len)),
  arg_types(TypeDecL,[RetType],EachArg),
  metta_anew1(Load,metta_params(Self,Fn,EachArg)),
  metta_anew1(Load,metta_return(Self,Fn,RetType)))),!.

/*do_metta(File,Self,Load,PredDecl, Src):-fail,
   metta_anew(Load,Src,metta_atom(Self,PredDecl)),
   ignore((PredDecl=['=',Head,Body], metta_anew(Load,Src,metta_defn(Self,Head,Body)))),
   ignore((Body == 'True',!,do_metta(File,Self,Load,Head))),
   nop((fn_append(Head,X,Head), fn_append(PredDecl,X,Body), metta_anew((Head:- Body)))),!.*/

asserted_do_metta2(Self,Load,[EQ,Head,Result], Src):- EQ=='=', !,
 must_det_ll((
    discover_head(Self,Load,Head),
    color_g_mesg_ok('#ffa500',metta_anew(Load,Src,metta_defn(Self,Head,Result))),
    discover_body(Self,Load,Result))).

asserted_do_metta2(Self,Load,PredDecl, Src):-
   ignore(discover_head(Self,Load,PredDecl)),
   color_g_mesg_ok('#ffa500',metta_anew(Load,Src,metta_atom(Self,PredDecl))).


always_exec(exec(W)):- !, is_list(W), always_exec(W).
always_exec(List):- \+ is_list(List),!,fail.
always_exec([Var|_]):- \+ atom(Var),!,fail.
always_exec(['extend-py!'|_]):- !, fail.
always_exec([H|_]):- atom_concat(_,'!',H),!. %pragma!/print!/transfer!/include! etc
always_exec(['assertEqualToResult'|_]):-!,fail.
always_exec(['assertEqual'|_]):-!,fail.
always_exec(_):-!,fail. % everything else

if_t(A,B,C):- trace,if_t((A,B),C).


check_answers_for(TermV,Ans):- (string(TermV);var(Ans);var(TermV)),!,fail.
check_answers_for(TermV,_):-  sformat(S,'~q',[TermV]),atom_contains(S,"[assert"),!,fail.
check_answers_for(_,Ans):- contains_var('BadType',Ans),!,fail.
%check_answers_for([TermV],Ans):- !, check_answers_for(TermV,Ans).
%check_answers_for(TermV,[Ans]):- !, check_answers_for(TermV,Ans).
check_answers_for(_,_).

got_exec_result2(Val,Nth,Ans):- is_list(Ans), exclude(==(','),Ans,Ans2), Ans\==Ans2,!,
  got_exec_result2(Val,Nth,Ans2).
got_exec_result2(Val,Nth,Ans):-
 must_det_ll((
  Nth100 is Nth+100,
  get_test_name(Nth100,TestName),
  nb_current(exec_src,Exec),
  if_t( ( \+ is_unit_test_exec(Exec)),
  ((equal_enough(Val,Ans)
     -> write_pass_fail_result_now(TestName,exec,Exec,'PASS',Ans,Val)
      ; write_pass_fail_result_now(TestName,exec,Exec,'FAIL',Ans,Val)))))).

write_pass_fail_result_now(TestName,exec,Exec,PASS_FAIL,Ans,Val):-
   (PASS_FAIL=='PASS'->flag(loonit_success, X, X+1);flag(loonit_failure, X, X+1)),
   (PASS_FAIL=='PASS'->Color=cyan;Color=red),
   color_g_mesg(Color,write_pass_fail_result_c(TestName,exec,Exec,PASS_FAIL,Ans,Val)),!,nl,
   nl,writeln('--------------------------------------------------------------------------'),!.

write_pass_fail_result_c(TestName,exec,Exec,PASS_FAIL,Ans,Val):-
  nl,write_mobj(exec,[(['assertEqualToResult',Exec,Ans])]),
  nl,write_src('!'(['assertEqual',Val,Ans])),
  write_pass_fail_result(TestName,exec,Exec,PASS_FAIL,Ans,Val).

is_unit_test_exec(Exec):- sformat(S,'~w',[Exec]),sub_atom(S,_,_,_,'assert').
is_unit_test_exec(Exec):- sformat(S,'~q',[Exec]),sub_atom(S,_,_,_,"!',").

return_empty('Empty').
return_empty(_,Empty):- return_empty(Empty).

convert_tax(_How,Self,Tax,Expr,NewHow):-
  metta_interp_mode(Ch,Mode),
  string_concat(Ch,TaxM,Tax),!,
  normalize_space(string(NewTax),TaxM),
  convert_tax(Mode,Self,NewTax,Expr,NewHow).
convert_tax(How,_Self,Tax,Expr,How):-
  %parse_sexpr_metta(Tax,Expr).
  normalize_space(string(NewTax),Tax),
  read_metta(NewTax,Expr).


metta_interp_mode('+',load).
metta_interp_mode('-',unload).
metta_interp_mode('!',exec).
metta_interp_mode('?',call).
metta_interp_mode('^',load_like_file).


call_sexpr(Mode,Self,Tax,_S,Out):-
  metta_interp_mode(Mode,How),
  (atom(Tax);string(Tax)),
    normalize_space(string(TaxM),Tax),
    convert_tax(How,Self,TaxM,Expr,NewHow),!,
    show_call(do_metta(python,NewHow,Self,Expr,Out)).


write_comment(_):- silent_loading,!.
write_comment(Cmt):- connlf,format(';;~w~n',[Cmt]).

do_metta(_File,_Load,_Self,In,Out):-  var(In),!,In=Out.
do_metta(_From,_Mode,_Self,end_of_file,'Empty'):- !. %, halt(7), writeln('\n\n% To restart, use: ?- repl.').
do_metta(_File,_Load,_Self,Cmt,Out):- Cmt==[],!, Out=[].

do_metta(From,Load,Self,'$COMMENT'(Expr,_,_),Out):- !, do_metta(From,comment(Load),Self,Expr,Out).
do_metta(From,Load,Self,'$STRING'(Expr),Out):- !, do_metta(From,comment(Load),Self,Expr,Out).
do_metta(From,comment(Load),Self,[Expr],Out):-  !, do_metta(From,comment(Load),Self,Expr,Out).
do_metta(From,comment(Load),Self,Cmt,Out):- write_comment(Cmt),  !,
   ignore(( atomic(Cmt),atomic_list_concat([_,Src],'MeTTaLog only: ',Cmt),!,atom_string(Src,SrcCode),do_metta(mettalog_only(From),Load,Self,SrcCode,Out))),
   ignore(( atomic(Cmt),atomic_list_concat([_,Src],'MeTTaLog: ',Cmt),!,atom_string(Src,SrcCode),do_metta(mettalog_only(From),Load,Self,SrcCode,Out))),!.

do_metta(From,How,Self,Src,Out):- string(Src),!,
    normalize_space(string(TaxM),Src),
    convert_tax(How,Self,TaxM,Expr,NewHow),!,
    do_metta(From,NewHow,Self,Expr,Out).

do_metta(From,_,Self,exec(Expr),Out):- !, do_metta(From,exec,Self,Expr,Out).
do_metta(From,_,Self,  call(Expr),Out):- !, do_metta(From,call,Self,Expr,Out).
do_metta(From,_,Self,     ':-'(Expr),Out):- !, do_metta(From,call,Self,Expr,Out).
do_metta(From,call,Self,TermV,FOut):- !,
   call_for_term_variables(TermV,Term,NamedVarsList,X), must_be(nonvar,Term),
   copy_term(NamedVarsList,Was),
   Output = NamedVarsList,
   user:interactively_do_metta_exec(From,Self,TermV,Term,X,NamedVarsList,Was,Output,FOut).
do_metta(_File,Load,Self,Src,Out):- Load\==exec, !, as_tf(asserted_do_metta(Self,Load,Src),Out).

do_metta(file(Filename),exec,Self,TermV,Out):-
  notrace((
     inc_exec_num(Filename),
    must_det_ll((
     get_exec_num(Filename,Nth),
     Nth>0)),
     file_answers(Filename, Nth, Ans),
     check_answers_for(TermV,Ans),!,
     must_det_ll((
      color_g_mesg_ok('#ffa500',
       (writeln(';; In file as:  '),
        color_g_mesg([bold,fg('#FFEE58')], write_src(exec(TermV))),
        write(';; To unit test case:'))))),!,
        do_metta_exec(file(Filename),Self,['assertEqualToResult',TermV,Ans],Out))).

do_metta(From,exec,Self,TermV,Out):- !, do_metta_exec(From,Self,TermV,Out).

do_metta_exec(From,Self,TermV,FOut):-
  Output = X,
   notrace(into_metta_callable(Self,TermV,Term,X,NamedVarsList,Was)),
   user:interactively_do_metta_exec(From,Self,TermV,Term,X,NamedVarsList,Was,Output,FOut).


call_for_term_variables(TermV,catch_red(show_failure(Term)),NamedVarsList,X):-
 term_variables(TermV, AllVars), call_for_term_variables4v(TermV,AllVars,Term,NamedVarsList,X),!,
 must_be(callable,Term).
call_for_term_variables(TermV,catch_red(show_failure(Term)),NamedVarsList,X):-
  get_term_variables(TermV, DCAllVars, Singletons, NonSingletons),
  call_for_term_variables5(TermV, DCAllVars, Singletons, NonSingletons, Term,NamedVarsList,X),!,
  must_be(callable,Term).

into_metta_callable(_Self,TermV,Term,X,NamedVarsList,Was):- use_metta_compiler, !,
 must_det_ll((((

 % ignore(Res = '$VAR'('ExecRes')),
  RealRes = Res,
  compile_for_exec(Res,TermV,ExecGoal),!,
  subst_vars(Res+ExecGoal,Res+Term,NamedVarsList),
  copy_term(NamedVarsList,Was),
  term_variables(Term,Vars),
  notrace((color_g_mesg('#114411',print_tree(exec(Res):-ExecGoal)))),
  %nl,writeq(Term),nl,
  ((\+ \+
  ((numbervars(v(TermV,Term,NamedVarsList,Vars),999,_,[attvar(bind)]),
  %nb_current(variable_names,NamedVarsList),
  %nl,print(subst_vars(Term,NamedVarsList,Vars)),
  nl)))),
  nop(maplist(verbose_unify,Vars)),
  %NamedVarsList=[_=RealRealRes|_],
  var(RealRes), X = RealRes)))),!.


into_metta_callable(Self,TermV,CALL,X,NamedVarsList,Was):-!,
 option_else('stack-max',StackMax,100),
 CALL = eval_args(StackMax,Self,Term,X),
 notrace(( must_det_ll((
 if_t(preview_compiler,write_compiled_exec(TermV,_Goal)),
  subst_vars(TermV,Term,NamedVarsList),
  copy_term(NamedVarsList,Was)
  %term_variables(Term,Vars),
  %nl,writeq(Term),nl,
  %skip((\+ \+
  %((numbervars(v(TermV,Term,NamedVarsList,Vars),999,_,[attvar(bind)]),  %nb_current(variable_names,NamedVarsList),
  %nl,print(subst_vars(TermV,Term,NamedVarsList,Vars)),nl)))),
  %nop(maplist(verbose_unify,Vars)))))),!.
  )))).



print_goals(TermV):- write_src(TermV).


/*do_metta_ exec(From,Mode,Self,TermV):- fail,
  return_empty(Empty),
  nb_setval(exec_src,TermV),
  findall(X,(interactively_do_metta_exec(From,Mode,Self,TermV,X,NamedVarsList,Was),
         ignore((must_det_ll((notrace(((color_g_mesg(yellow,
         ((write(' '), write_src(X),nl,
            (NamedVarsList\=@=Was-> (color_g_mesg(green,writeq(NamedVarsList)),nl); true),
            ignore(( \+ is_list(X),compound(X),format(' % '),writeq(X),nl,X\==Empty))))))))))))),_XL),!.
do_metta_ exec(From,Mode,Self,TermV):-
  \+ \+ write_exec(TermV),
  into_metta_callable(Self,TermV,Term,X,NamedVarsList,Was),
  Control = contrl(each),
  forall(may_rtrace(Term),
    (( notrace(ignore(((color_g_mesg(yellow,
     ((write(' '),
        write_src(X),nl,
        (NamedVarsList\=@=Was-> (color_g_mesg(green,write_src(NamedVarsList)),nl); true),
        ignore(( \+ is_list(X),compound(X),format(' % '),write_src(X),nl))))))))),
       Control \= contrl(leap),
       (read_pending_input(current_input,_,[]),
        ((Control = contrl(leap))-> fail ;
         (
          (write("press ';', '<enter>' or 'l': "),get_single_char(C)),
           (C==108->nb_setarg(1,Control,leap);(C==103->print_goals(Term);(C==59->true;(C==13->(!,fail))))))))))).

do_metta_ exec(From,Mode,_Self,TermV,X,NamedVarsList,Was):- use_metta_compiler, !,
 (( /*must_det_ll*/((
  write_exec(TermV),
 % ignore(Res = '$VAR'('ExecRes')),
  RealRes = Res,
  compile_for_exec(Res,TermV,ExecGoal),!,
  subst_vars(Res+ExecGoal,Res+Term,NamedVarsList),
  copy_term(NamedVarsList,Was),
  term_variables(Term,Vars),
  %nl,writeq(Term),nl,
  ((\+ \+
  ((numbervars(v(TermV,Term,NamedVarsList,Vars),999,_,[attvar(bind)]),
  %nb_current(variable_names,NamedVarsList),
  nl,print(subst_vars(Term,NamedVarsList,Vars)),nl)))),
  nop(maplist(verbose_unify,Vars)))))),
  %NamedVarsList=[_=RealRealRes|_],
  var(RealRes),
  X = RealRes,
  may_rtrace(Term).

do_metta_ exec(From,Mode,Self,TermV,X,NamedVarsList,Was):-!,
 notrace(( must_det_ll((
  if_t(preview_compiler,write_compiled_exec(TermV,_Goal)),
  \+ \+ write_exec(TermV),
  subst_vars(TermV,Term,NamedVarsList),
  copy_term(NamedVarsList,Was),
  term_variables(Term,Vars),
  %nl,writeq(Term),nl,
  skip((\+ \+
  ((numbervars(v(TermV,Term,NamedVarsList,Vars),999,_,[attvar(bind)]),
  %nb_current(variable_names,NamedVarsList),
  nl,print(subst_vars(TermV,Term,NamedVarsList,Vars)),nl)))),
  option_else('stack-max',StackMax,100),
  nop(maplist(verbose_unify,Vars)))))),
  may_rtrace(eval_args(StackMax,Self,Term,X)).
*/



%repl:- option_value('repl',prolog),!,prolog.
%:- ensure_loaded(metta_toplevel).

%:- discontiguous do_metta_exec/3.

repl:- setup_call_cleanup(flag(repl_level,Was,Was+1),repl0,
  (flag(repl_level,_,Was),(Was==0 -> maybe_halt(7) ; true))).

repl0:-
  catch(catch(repl1,'$aborted',true),end_of_input,true).

repl1:-
   %notrace((current_input(In),nop(catch(load_history,_,true)))),
  % ignore(install_readline(In)),
   repeat,
     %with_option(not_a_reload,true,make),
      catch(repl2,restart_reading,true),fail.
repl2:-
     notrace(( flag(eval_num,_,0),
      current_space(Self),
      ((nb_current(read_mode,Mode),Mode\==[])->true;Mode='!'),
      shell('stty sane ; stty echo'),
      current_input(In),
      format(atom(P),'metta ~w ~w> ',[Self, Mode]))),
      setup_call_cleanup(
         notrace(prompt(Was,P)),
         notrace((ttyflush,read_metta(In,Expr),ttyflush)),
         notrace(prompt(_,Was))),
      ignore(shell('stty sane ; stty echo')),
      ignore(check_has_directive(Expr)),
    (notrace(Expr==end_of_file)
       -> throw(end_of_input) ; (once((do_metta(repl_true,Mode,Self,Expr,_))),fail)).

check_has_directive(Atom):- atom(Atom),atom_concat(_,'.',Atom),!.
check_has_directive(call(N=V)):- nonvar(N),!, set_directive(N,V).
check_has_directive(call(Rtrace)):- rtrace == Rtrace,!, rtrace,notrace(throw(restart_reading)).
check_has_directive(NEV):- atom(NEV), atomic_list_concat([N,V],'=',NEV), set_directive(N,V).
check_has_directive([AtEq,Value]):-atom(AtEq),atom_concat('@',Name,AtEq), set_directive(Name,Value).
check_has_directive(ModeChar):- atom(ModeChar),metta_interp_mode(ModeChar,_Mode),!,set_directive(read_mode,ModeChar).
check_has_directive(AtEq):-atom(AtEq),atom_concat('@',NEV,AtEq),check_has_directive(NEV,true).
check_has_directive(_).
set_directive(N,V):- atom_concat('@',NN,N),!,set_directive(NN,V).
set_directive(N,V):- N==mode,!,set_directive(read_mode,V).
set_directive(N,V):- show_call(set_option_value(N,V)),!,notrace(throw(restart_reading)).

read_pending_white_codes(In):-
  read_pending_codes(In,[10],[]),!.
read_pending_white_codes(_).

call_for_term_variables4v(Term,[]  ,as_tf(Term,TF),NamedVarsList,TF):- get_global_varnames(NamedVarsList),!.
call_for_term_variables4v(Term,[X]  ,       Term,      NamedVarsList,X):- get_global_varnames(NamedVarsList).


not_in_eq(List, Element) :-
    member(V, List), V == Element.

get_term_variables(Term, DontCaresN, CSingletonsN, CNonSingletonsN) :-
    term_variables(Term, AllVars),
    get_global_varnames(VNs),
    writeqln(term_variables(Term, AllVars)=VNs),
    term_singletons(Term, Singletons),
    term_dont_cares(Term, DontCares),
    include(not_in_eq(Singletons), AllVars, NonSingletons),
    include(not_in_eq(DontCares), NonSingletons, CNonSingletons),
    include(not_in_eq(DontCares), Singletons, CSingletons),
    maplist(into_named_vars,[DontCares, CSingletons,  CNonSingletons],
                           [DontCaresN, CSingletonsN, CNonSingletonsN]),
    writeqln([DontCaresN, CSingletonsN, CNonSingletonsN]).

term_dont_cares(Term, DontCares):-
  term_variables(Term, AllVars),
  get_global_varnames(VNs),
  include(has_sub_var(AllVars),VNs,HVNs),
  include(underscore_vars,HVNs,DontCareNs),
  maplist(arg(2),DontCareNs,DontCares).

into_named_vars(Vars,L):- is_list(Vars), !, maplist(name_for_var_vn,Vars,L).
into_named_vars(Vars,L):- term_variables(Vars,VVs),!,into_named_vars(VVs,L).

has_sub_var(AllVars,_=V):- sub_var(V,AllVars).
underscore_vars(V):- var(V),!,name_for_var(V,N),!,underscore_vars(N).
underscore_vars(N=_):- !, atomic(N),!,underscore_vars(N).
underscore_vars(N):- atomic(N),!,atom_concat('_',_,N).

get_global_varnames(VNs):- nb_current('variable_names',VNs),VNs\==[],!.
get_global_varnames(VNs):- prolog_load_context(variable_names,VNs),!.
maybe_set_var_names(List):- List==[],!.
maybe_set_var_names(List):- % wdmsg(maybe_set_var_names(List)),
   is_list(List),!,nb_linkval(variable_names,List).
maybe_set_var_names(_).

name_for_var_vn(V,N=V):- name_for_var(V,N).

name_for_var(V,N):- var(V),!,get_global_varnames(VNs),member(N=VV,VNs),VV==V,!.
name_for_var(N=_,N):- !.
name_for_var(V,N):- term_to_atom(V,N),!.


  %call_for_term_variables5(Term,[],as_tf(Term,TF),[],TF):- atom(Term),!.
call_for_term_variables5(Term,[],[],[],as_tf(Term,TF),[],TF):- ground(Term),!.
call_for_term_variables5(Term,DC,[],[],call_nth(Term,TF),DC,TF):- ground(Term),!.
call_for_term_variables5(Term,_,[],[_=Var],call_nth(Term,Count),['Count'=Count],Var).
call_for_term_variables5(Term,_,[_=Var],[],call_nth(Term,Count),['Count'=Count],Var).
call_for_term_variables5(Term,_,Vars,[_=Var],Term,Vars,Var).
call_for_term_variables5(Term,_,[_=Var],Vars,Term,Vars,Var).
call_for_term_variables5(Term,_,SVars,Vars,call_nth(Term,Count),[Vars,SVars],Count).



is_interactive(From):- notrace(is_interactive0(From)).
is_interactive0(From):- From==false,!,fail.
is_interactive0(From):- atomic(From),is_stream(From),!, \+ stream_property(From,filename(_)).
is_interactive0(From):- From = repl_true,!.
is_interactive0(From):- From = true,!.


:- set_prolog_flag(history, 20).

inside_assert(Var,Var):- \+ compound(Var),!.
inside_assert([H,IA,_],IA):- atom(H),atom_concat('assert',_,H),!.
inside_assert(Conz,Conz):- is_conz(Conz),!.
inside_assert(exec(I),O):- !, inside_assert(I,O).
inside_assert(Eval,O):- functor(Eval,eval_args,A), A1 is A-1, arg(A1,Eval,I),!, inside_assert(I,O).
inside_assert(eval_args(A,B,I,C),eval_args(A,B,O,C)):- !, inside_assert(I,O).
inside_assert(eval_args(I,C),eval_args(O,C)):- !, inside_assert(I,O).
inside_assert(call(I),O):- !, inside_assert(I,O).
inside_assert( ?-(I), O):- !, inside_assert(I,O).
inside_assert( :-(I), O):-  !, inside_assert(I,O).
inside_assert(Var,Var).

current_space(Self):- ((nb_current(self_space,Self),Self\==[])->true;Self='&self').

eval(all(Form)):- nonvar(Form), !, forall(eval(Form,_),true).
eval(Form):-
  current_space(Self),
   do_metta(true,exec,Self,Form,_Out).

eval(Form,Out):-
  current_space(Self),
   do_metta(prolog,exec,Self,Form,Out).

name_vars(X='$VAR'(X)).

interactively_do_metta_exec(From,Self,TermV,Term,X,NamedVarsList,Was,Output,FOut):-
  notrace((
    inside_assert(Term,BaseEval),
    \+ \+ write_exec(TermV),
    option_else(answer,Leap,each),
    Control = contrl(Leap),
    % Initialize Control as a compound term with 'each' as its argument.
    %GG = interact(['Result'=X|NamedVarsList],Term,trace_off),
    (((From = file(_Filename), option_value('exec',skip),  \+ always_exec(BaseEval)))
     -> GG = (skip(Term),deterministic(Complete))
        ; GG =          (Term,deterministic(Complete))),
    Result = res(FOut),
    !, % metta_toplevel
   flag(result_num,_,0),
  \+ \+ (
    maplist(name_vars,NamedVarsList),
    name_vars('OUT'=X),
   add_history_src(exec(BaseEval)),
  color_g_mesg('#fa90f6', (write('; '), with_indents(false,write_src(exec(BaseEval))))),
  color_g_mesg('#da70d6', (write('% DEBUG: '), writeq(eval_args(100,Self,BaseEval,X)),writeln('.')))))),

   (forall_interactive(
    From, WasInteractive,may_rtrace(GG),
     ( (Complete==true->!;true),
       %repeat,
       nb_setarg(1,Result,Output),
       read_pending_codes(user_input,_,[]),
       flag(result_num,R,R+1),
       flag(result_num,ResNum,ResNum),
       (((ResNum==1,Complete==true)->(format('~NDeterministic: ',  []), !);          %or Nondet
           ( Complete==true -> (format('~NLast Result(~w): ',[R]),! );
                               format('~NNDet Result(~w): ',[R])))),
       color_g_mesg(yellow, ignore((( if_t( \+ atomic(Output), nl), write_src(Output), nl)))),
       color_g_mesg(green,
           ignore((NamedVarsList \=@= Was ->( maplist(print_var,NamedVarsList), nl) ; true))),
       ((Complete\==true, WasInteractive, Control \== contrl(leap))->
         (write("More Solutions? "),get_single_char_key(C), writeq(key=C),nl,
         (C=='b' -> (once(repl),fail) ;
         (C=='m' -> make ;
         (C=='t' -> set_debug(eval,true) ;
         (C==';' -> true ;
         (C==esc('[A',[27,91,65]) -> nb_setarg(1, Control, leap) ;
         (C=='l' -> nb_setarg(1, Control, leap) ;
         (((C=='\n');(C=='\r')) -> (!,fail);
         (!,fail))))))))));((Complete==true) ->! ; true)))
                    *-> (Result = res(FOut))
                    ; (flag(result_num,ResNum,ResNum),(ResNum==0->(format('~N<no-results>~n~n'),!,fail);true))).


get_single_char_key(O):- get_single_char(C),get_single_char_key(C,O).
get_single_char_key(27,esc(A,[27|O])):- !,read_pending_codes(user_input,O,[]),name(A,O).
get_single_char_key(C,A):- name(A,[C]).

forall_interactive(file(_),false,Goal,After):- !, forall(Goal,After).
forall_interactive(prolog,false,Goal,After):- !, Goal,ignore(After).
forall_interactive(From,WasInteractive,Goal,After):-
   (is_interactive(From) -> WasInteractive = true ; WasInteractive = false),!,
    forall(Goal,After).

print_var(Name=Var) :- print_var(Name,Var).
print_var(Name,Var):-  write('$'),write(Name), write(' = '), write_src(Var), nl.

% Entry point for the user to call with tracing enabled
toplevel_goal(Goal) :-
   term_variables(Goal,Vars),
    trace_goal(Vars, Goal, trace_off).

% Entry point for the user to call with tracing enabled
trace_goal(Goal) :-
    trace_goal(Goal, trace_on).

% Handle tracing
trace_goal(Goal, Tracing) :-
    (Tracing == trace_on -> writeln('Entering goal:'), writeln(Goal) ; true),
    term_variables(Goal, Variables),
    ( call(Goal) ->
        (Tracing == trace_on -> writeln('Goal succeeded with:'), writeln(Variables) ; true),
        interact(Variables, Goal, Tracing)
    ;   (Tracing == trace_on -> writeln('Goal failed.') ; true),
        false
    ).

% Interaction with the user
interact(Variables, Goal, Tracing) :-
    call(Goal),write('Solution: '), write_src(Variables),
    write(' [;next]?'),
    get_single_char(Code),
    (command(Code, Command) ->
        handle_command(Command, Variables, Goal, Tracing)
    ;   writeln('Unknown command.'), interact(Variables, Goal, Tracing) % handle unknown commands
    ).

install_readline(Input):-
    add_history_string("!(pfb3)"),
    add_history_string("!(load-flybase-full)"),
    add_history_string("!(obo-alt-id $X BS:00063)"),
    add_history_string("!(and (total-rows $T TR$) (unique-values $T2 $Col $TR))"),
    ignore(editline:el_wrap),
    ignore(editline:add_prolog_commands(Input)).




% Command descriptions
command(59, retry).    % ';' to retry
command(115, skip).    % 's' to skip to the next solution
command(108, leap).    % 'l' to leap (end the debugging session)
command(103, goals).   % 'g' to show current goals
command(102, fail).    % 'f' to force fail
command(116, trace).   % 't' to toggle tracing
command(117, up).      % 'u' to continue without interruption
command(101, exit).    % 'e' to exit the debugger
command(97, abort).    % 'a' to abort
command(98, break).    % 'b' to set a breakpoint
command(99, creep).    % 'c' to proceed step by step
command(104, help).    % 'h' for help
command(65, alternatives).    % 'A' for alternatives
command(109, make).       % 'm' for make (recompile)
command(67, compile).     % 'C' for Compile (compile new executable)

:- style_check(-singleton).

% Command implementations
handle_command(make, Variables, Goal, Tracing) :-
    writeln('Recompiling...'),
    % Insert the logic to recompile the code.
    % This might involve calling `make/0` or similar.
    make,  % This is assuming your Prolog environment has a `make` predicate.
    fail. % interact(Variables, Goal, Tracing).

handle_command(compile, Variables, Goal, Tracing) :-
    writeln('Compiling new executable...'),
    % Insert the logic to compile a new executable.
    % This will depend on how you compile Prolog programs in your environment.
    % For example, you might use `qsave_program/2` to create an executable.
    % Pseudocode: compile_executable(ExecutableName)
    fail. % interact(Variables, Goal, Tracing).
handle_command(alternatives, Variables, Goal, Tracing) :-
    writeln('Showing alternatives...'),
    % Here you would include the logic for displaying the alternatives.
    % For example, showing other clauses that could be tried for the current goal.
    writeln('Alternatives for current goal:'),
    writeln(Goal),
    % Pseudocode: find_alternatives(Goal, Alternatives)
    % Pseudocode: print_alternatives(Alternatives)
    fail. % interact(Variables, Goal, Tracing).
% Extend the command handling with the 'help' command implementation
handle_command(help, Variables, Goal, Tracing) :-
    print_help,
    fail. % interact(Variables, Goal, Tracing).
handle_command(abort, _, _, _) :-
    writeln('Aborting...'), abort.
handle_command(break, Variables, Goal, Tracing) :-
    writeln('Breakpoint set.'), % Here you should define what 'setting a breakpoint' means in your context
    fail. % interact(Variables, Goal, Tracing).
handle_command(creep, Variables, Goal, Tracing) :-
    writeln('Creeping...'), % Here you should define how to 'creep' (step by step execution) through the code
    trace. % interact(Variables, Goal, Tracing).
handle_command(retry, Variables, Goal, Tracing) :-
    writeln('Continuing...'),!.
    %trace_goal(Goal, Tracing).
handle_command(skip, Variables, Goal, Tracing) :-
    writeln('Skipping...').
handle_command(leap, _, _, _) :-
    writeln('Leaping...'), nontrace. % Cut to ensure we stop the debugger
handle_command(goals, Variables, Goal, Tracing) :-
    writeln('Current goal:'), writeln(Goal),
    writeln('Current variables:'), writeln(Variables),
    bt,fail. % interact(Variables, Goal, Tracing).
handle_command(fail, _, _, _) :-
    writeln('Forcing failure...'), fail.
handle_command(trace, Variables, Goal, Tracing) :-
    (Tracing == trace_on ->
        NewTracing = trace_off, writeln('Tracing disabled.')
    ;   NewTracing = trace_on, writeln('Tracing enabled.')
    ),
    interact(Variables, Goal, NewTracing).
handle_command(up, Variables, Goal, Tracing) :-
    writeln('Continuing up...'),
    repeat,
    ( trace_goal(Goal, Tracing) -> true ; !, fail ).
handle_command(exit, _, _, _) :-
    writeln('Exiting debugger...'), !. % Cut to ensure we exit the debugger

:- style_check(+singleton).


% Help description
print_help :-
    writeln('Debugger commands:'),
    writeln('(;)  next             - Retry with next solution.'),
    writeln('(g)  goal             - Show the current goal.'),
    writeln('(u)  up               - Finish this goal without interruption.'),
    writeln('(s)  skip             - Skip to the next solution.'),
    writeln('(c)  creep or <space> - Proceed step by step.'),
    writeln('(l)  leap             - Leap over (the debugging).'),
    writeln('(f)  fail             - Force the current goal to fail.'),
    writeln('(B)  back             - Go back to the previous step.'),
    writeln('(t)  trace            - Toggle tracing on or off.'),
    writeln('(e)  exit             - Exit the debugger.'),
    writeln('(a)  abort            - Abort the current operation.'),
    writeln('(b)  break            - Break to a new sub-REPL.'),
    writeln('(h)  help             - Display this help message.'),
    writeln('(A)  alternatives     - Show alternative solutions.'),
    writeln('(m)  make             - Recompile/Update the current running code.'),
    writeln('(C)  compile          - Compile a fresh executable (based on the running state).'),
    writeln('(E)  error msg        - Show the latest error messages.'),
    writeln('(r)  retry            - Retry the previous command.'),
    writeln('(I)  info             - Show information about the current state.'),
    !.



write_compiled_exec(Exec,Goal):-
%  ignore(Res = '$VAR'('ExecRes')),
  compile_for_exec(Res,Exec,Goal),
  notrace((color_g_mesg('#114411',portray_clause(exec(Res):-Goal)))).

verbose_unify(Term):- verbose_unify(trace,Term).
verbose_unify(What,Term):- term_variables(Term,Vars),maplist(verbose_unify0(What),Vars),!.
verbose_unify0(What,Var):- put_attr(Var,verbose_unify,What).
verbose_unify:attr_unify_hook(Attr, Value) :-
    format('~N~q~n',[verbose_unify:attr_unify_hook(Attr, Value)]),
    vu(Attr,Value).
vu(_Attr,Value):- is_ftVar(Value),!.
vu(fail,_Value):- !, fail.
vu(true,_Value):- !.
vu(trace,_Value):- trace.
:- nodebug(metta(eval)).
:- nodebug(metta(exec)).

really_trace:- once(option_value('exec',rtrace);option_value('eval',rtrace);is_debugging((exec));is_debugging((eval))).
% !(pragma! exec rtrace)
may_rtrace(Goal):- really_trace,!,  really_rtrace(Goal).
may_rtrace(Goal):- time_eval((Goal))*->true;really_rtrace(Goal).
really_rtrace(Goal):- use_metta_compiler,!,rtrace(call(Goal)).
really_rtrace(Goal):- with_debug((eval),with_debug((exec),Goal)).




% Measures the execution time of a Prolog goal and displays the duration in seconds,
% milliseconds, or microseconds, depending on the execution time.
%
% Args:
%   - Goal: The Prolog goal to be executed and timed.
%
% The predicate uses the `statistics/2` predicate to measure the CPU time before
% and after executing the provided goal. It calculates the elapsed time in seconds
% and converts it to milliseconds and microseconds. The output is formatted to
% provide clear timing information:
%
% - If the execution takes more than 2 seconds, it displays the time in seconds.
% - If the execution takes between 1 millisecond and 2 seconds, it displays the time
%   in milliseconds.
% - If the execution takes less than 1 millisecond, it displays the time in microseconds.
%
% Example usage:
%   ?- time_eval(my_goal(X)).
%
%   ?- time_eval(sleep(0.95)).
%
% Output examples:
%   ; Evaluation took 2.34 seconds.
%   ; Evaluation took 123.45 ms.
%   ; Evaluation took 0.012 ms. (12.33 microseconds)
%
time_eval(Goal):-
  time_eval('Evaluation',Goal).
time_eval(What,Goal) :-
    statistics(cputime, Start),
    call(Goal),
    statistics(cputime, End),
    Seconds is End - Start,
    Milliseconds is Seconds * 1_000,
    (Seconds > 2
        -> format('; ~w took ~2f seconds.~n', [What, Seconds])
        ; (Milliseconds >= 1
            -> format('; ~w took ~3f secs. (~2f milliseconds) ~n', [What, Seconds, Milliseconds])
            ;( Micro is Milliseconds * 1_000,
              format('; ~w took ~6f secs. (~2f microseconds) ~n', [What, Seconds, Micro])))).




catch_red(Term):- catch(Term,E,pp_m(red,in(Term,E))).

s2p(I,O):- sexpr_s2p(I,O),!.


discover_head(Self,Load,Head):-
 ignore(([Fn|PredDecl]=Head,
 nop(( arg_types(PredDecl,[],EachArg),
  metta_anew1(Load,metta_head(Self,Fn,EachArg)))))).

discover_body(Self,Load,Body):-
  nop(( [Fn|PredDecl] = Body, arg_types(PredDecl,[],EachArg),
  metta_anew1(Load,metta_body(Self,Fn,EachArg)))).

decl_length(TypeDecL,Len):- is_list(TypeDecL),!,length(TypeDecL,Len).
decl_length(_TypeDecL,1).

arg_types([['->'|L]],R,LR):-!, arg_types(L,R,LR).
arg_types(['->'|L],R,LR):-!, arg_types(L,R,LR).
arg_types(L,R,LR):- append(L,R,LR).

%:- ensure_loaded('../../examples/factorial').
%:- ensure_loaded('../../examples/fibonacci').

%print_preds_to_functs:-preds_to_functs_src(factorial_tail_basic)

:- dynamic(began_loon/1).
loon:- loon(typein).

catch_red_ignore(G):- catch_red(G)*->true;true.

:- export(loon/1).
:- public(loon/1).

%loon(Why):- began_loon(Why),!,wdmsg(begun_loon(Why)).
loon(Why):- is_compiling,!,wdmsg(compiling_loon(Why)),!.
%loon( _Y):- current_prolog_flag(os_argv,ArgV),member('-s',ArgV),!.
loon(Why):- is_compiled, Why\==toplevel,Why\==default, Why\==program,!,wdmsg(compiled_loon(Why)),!.
loon(Why):- began_loon(_),!,wdmsg(skip_loon(Why)).
loon(Why):- wdmsg(began_loon(Why)), assert(began_loon(Why)),
  do_loon.

do_loon:-
 ignore((
  \+ prolog_load_context(reloading,true),
  maplist(catch_red_ignore,[

   metta_final,
   load_history,
   update_changed_files,
  (option_value('prolog',true)->true;
    (run_cmd_args,(option_value('repl',false)->true;repl), loonit_report, maybe_halt(7)))]))),!.

%loon:- time(loon_metta('./examples/compat/test_scripts/*.metta')),fail.
%loon:- repl, (option_value('halt',false)->true;halt(7)).
maybe_halt(Seven):- option_value('repl',true),!,halt(Seven).
maybe_halt(Seven):- option_value('halt',true),!,halt(Seven).
maybe_halt(Seven):- wdmsg(maybe_halt(Seven)).

is_compiling:- current_prolog_flag(os_argv,ArgV),member(E,ArgV),
  (E==qcompile_mettalog;E==qsave_program),!.
is_compiled:- current_prolog_flag(os_argv,ArgV),\+ member('swipl',ArgV),!.
is_converting:- nb_current('convert','True'),!.
is_converting:- current_prolog_flag(os_argv,ArgV), member('--convert',ArgV),!.
show_os_argv:- current_prolog_flag(os_argv,ArgV),write('; libswipl: '),writeln(ArgV).
is_pyswip:- current_prolog_flag(os_argv,ArgV),member( './',ArgV).
%  libswipl: ['./','-q',--home=/usr/local/lib/swipl]

:- initialization(show_os_argv).

:- initialization(loon(program),program).
:- initialization(loon(default)).

ensure_mettalog_system:-
    abolish(began_loon/1),
    dynamic(began_loon/1),
    system:use_module(library(quasi_quotations)),
    system:use_module(library(hashtable)),
    system:use_module(library(gensym)),
    system:use_module(library(sort)),
    system:use_module(library(writef)),
    system:use_module(library(rbtrees)),
    system:use_module(library(dicts)),
    system:use_module(library(shell)),
    system:use_module(library(edinburgh)),
  %  system:use_module(library(lists)),
    system:use_module(library(statistics)),
    system:use_module(library(nb_set)),
    system:use_module(library(assoc)),
    system:use_module(library(pairs)),
    user:use_module(library(swi_ide)),
    user:use_module(library(prolog_profile)),
    ensure_loaded('./metta_vspace/pyswip/flybase_convert'),
    ensure_loaded('./metta_vspace/pyswip/flybase_main'),
    autoload_all,
    make,
    autoload_all,
    %pack_install(predicate_streams, [upgrade(true),global(true)]),
    %pack_install(logicmoo_utils, [upgrade(true),global(true)]),
    %pack_install(dictoo, [upgrade(true),global(true)]),
    !.

file_save_name(E,_):- \+ atom(E),!,fail.
file_save_name(E,Name):- file_base_name(E,BN),BN\==E,!,file_save_name(BN,Name).
file_save_name(E,E):- atom_concat('Sav.',_,E),!.
file_save_name(E,E):- atom_concat('Bin.',_,E),!.
before_underscore(E,N):-atomic_list_concat([N|_],'_',E),!.
save_name(Name):- current_prolog_flag(os_argv,ArgV),member(E,ArgV),file_save_name(E,Name),!.
next_save_name(Name):- save_name(E),
  before_underscore(E,N),
  atom_concat(N,'_',Stem),
  gensym(Stem,Name),
  \+ exists_file(Name),
  Name\==E,!.
next_save_name('Sav.MeTTaLog').
qcompile_mettalog:-
    ensure_mettalog_system,
    catch(qsave_program('Sav.MeTTaLog',
        [class(development),autoload(true),goal(loon(goal)), toplevel(loon(toplevel)), stand_alone(true)]),E,writeln(E)),
    halt(0).
qsave_program:-  ensure_mettalog_system, next_save_name(Name),
    catch(qsave_program(Name,
        [class(development),autoload(true),goal(loon(goal)), toplevel(loon(toplevel)), stand_alone(false)]),E,writeln(E)),
    !.


:- initialization(update_changed_files,restore).

:- ignore(((
   \+ prolog_load_context(reloading,true),
    initialization(loon(restore),restore),
   metta_final
   ))).



:- set_prolog_flag(metta_interp,ready).