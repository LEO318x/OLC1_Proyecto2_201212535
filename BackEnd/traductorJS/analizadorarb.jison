/* Importaciones  */
%{
let lisErrorLexico = [], lisErrorSintactico = [], lisTokens = [], lisTraduccion = [];
let arbolJSON;
%}

/* Analizador Lexico */
%lex
%options case-sensitive 

%%

// Er. Espacios en blanco
\s+                                 {  }

/***************************************
*                                      *
*------------>COMENTARIOS<-------------*
*                                      *
****************************************/

//Comentario Unilínea
"//".*  {}

//Comentario Multilínea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] {}

/***************************************
*                                      *
*---------->EXP. REGULARES<------------*
*                                      *
****************************************/
// Er. Cadena Comilla Doble         
[\"][^\\\"]*([\\][\\\"ntr][^\\\"]*)*[\"]        { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_cadena', yytext]); return 'tk_cadena'}

// Er. Cadena Comilla Simple
[\'][^\\\']*([\\][\\\'ntr][^\\\']*)*[']         { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_cadenasimple', yytext]); return 'tk_cadenasimple' }

// Er. Número decimal
[0-9]+(\.[0-9]+)\b                  { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_decimal', yytext]); return 'tk_decimal';}

// Er. Número entero
[0-9]+\b                            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_entero', yytext]); return 'tk_entero'; }
     

/***************************************
*                                      *
*-------->PALABRAS RESERVADAS<---------*
*                                      *
****************************************/

"public"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_public', yytext]); return 'tk_public'; }
"class"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_class', yytext]); return 'tk_class'; }
"interface"         { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_interface', yytext]); return 'tk_interface'; }
"void"              { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_void', yytext]); return 'tk_void'; }
"main"              { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_main', yytext]); return 'tk_main'; }
"static"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_static', yytext]); return 'tk_static'; }
"for"               { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_for', yytext]); return 'tk_for'; }
"while"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_while', yytext]); return 'tk_while'; }
"do"                { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_do', yytext]); return 'tk_do'; }
"if"                { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_if', yytext]); return 'tk_if'; }
"else"              { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_else', yytext]); return 'tk_else'; }
"int"               { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_int', yytext]); return 'tk_int'; }
"boolean"           { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_boolean', yytext]); return 'tk_boolean'; }
"double"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_double', yytext]); return 'tk_double'; }
"String"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_String', yytext]); return 'tk_String'; }
"char"              { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_char', yytext]); return 'tk_char'; }
"true"              { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_true', yytext]); return 'tk_true'; }
"false"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_false', yytext]); return 'tk_false'; }
"break"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_break', yytext]); return 'tk_break'; }
"continue"          { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_continue', yytext]); return 'tk_continue'; }
"return"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_return', yytext]); return 'tk_return'; }
"System"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_system', yytext]); return 'tk_system'; }
"out"               { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_out', yytext]); return 'tk_out'; }
"print"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_print', yytext]); return 'tk_print'; }
"println"           { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_println', yytext]); return 'tk_println'; }


/***************************************
*                                      *
*-------------->SIMBOLOS<--------------*
*                                      *
****************************************/

// Símbolos de apertura y cerradura
"("             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_para', yytext]); return 'tk_para'; }
")"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_parc', yytext]); return 'tk_parc'; }
"{"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_llaa', yytext]); return 'tk_llaa'; }
"}"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_llac', yytext]); return 'tk_llac'; }
"["             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_cora', yytext]); return 'tk_cora'; }
"]"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_corc', yytext]); return 'tk_corc'; }

// Lógicos
"&&"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_and', yytext]); return 'tk_and'; }
"||"            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_or', yytext]); return 'tk_or'; }
"^"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_xor', yytext]); return 'tk_xor'; }

// Relacionales
">="            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_mayorigual', yytext]); return 'tk_mayorigual'; }
"<="            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_menorigual', yytext]); return 'tk_menorigual'; }
"=="            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_dobleigual', yytext]); return 'tk_dobleigual'; }
"!="            { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_diferente', yytext]); return 'tk_diferente'; }
">"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_mayorq', yytext]); return 'tk_mayorq'; }
"<"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_menorq', yytext]); return 'tk_menorq'; }

// Lógicos
"!"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_not', yytext]); return 'tk_not'; }

// Operacionales
"+"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_mas', yytext]); return 'tk_mas'; }
"-"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_menos', yytext]); return 'tk_menos'; }
"*"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_multi', yytext]); return 'tk_multi'; }
"/"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_div', yytext]); return 'tk_div'; }

// Símbolos de separación
"="             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_igual', yytext]); return 'tk_igual'; }
"."             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_punto', yytext]); return 'tk_punto'; }
","             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_coma', yytext]); return 'tk_coma'; }
":"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_dospuntos', yytext]); return 'tk_dospuntos'; }
";"             { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_puntocoma', yytext]); return 'tk_puntocoma'; }

/***************************************
*                                      *
*---------->EXP. REGULARES 2<----------*
*                                      *
****************************************/


// Er. Identificador
([a-zA-Z_])[a-zA-Z0-9_]*                        { lisTokens.push([yylloc.first_line, yylloc.first_column, 'tk_identificador', yytext]); return 'tk_identificador'; }


//Fin del Archivo
<<EOF>>	        { return 'EOF'; } 


// Error Lexico
. {
    lisErrorLexico.push(["Fila: "+yylloc.first_line, "Columna: "+yylloc.first_column, "Descripcion: "+yytext]); 
}

/lex

/***************************************
*                                      *
*------->ANALISIS SINTÁCTICO<----------*
*                                      *
****************************************/
//Precedencia de operadores

// Lógicos
%left 'tk_and' 'tk_or' 'tk_xor'

// Relacionales
%left 'tk_menorq' 'tk_mayorq' 'tk_menorigual' 'tk_mayorigual' 'tk_dobleigual' 'tk_diferente'

// Operaciones Aritméticas
%left 'tk_mas' 'tk_menos'
%left 'tk_multi' 'tk_div'

// Negación y Menos de número Negativo
%left 'tk_not' 'MENOSNUMERO'

// Return
%left 'tk_return'

%start INICIO

%%
INICIO
    : TODO EOF                     { /*console.log($1);*/ /*return { name: 'RAIZ', children: $1 };*/ arbolJSON = { name: 'RAIZ', children: $1 }; } 
    ;

TODO
    : INSTRUCCIONESTODO                     {$$=[{name: 'INSTRUCCIONESTODO', children: $1}];}
    |
    ;

INSTRUCCIONESTODO
    : LISTASINTAXIS                         {$$=[{name: 'LISTASINTAXIS', children: $1}];}
    | INSTRUCCIONESTODO LISTASINTAXIS       { $1.push( { name: 'LISTASINTAXIS', children: $2 } ); $$ = $1; }
    ;

LISTASINTAXIS
    : SINTAXISCLASE                         {$$=[{name: 'SINTAXISCLASE', children: $1}];}
    | SINTAXISINTERFACE                     {$$=[{name: 'SINTAXISINTERFACE', children: $1}];}
    | ERROR2
    ;

/*------------------------------------*
*                                     *
*________________CLASE________________*
*                                     *
*-------------------------------------*/
SINTAXISCLASE
    : tk_public tk_class tk_identificador tk_llaa TODOCLASE tk_llac {$$=[{name: $1},{name: $2},{name: $3},{name: $4},{name: 'TODOCLASE', children: $5},{name: $6}];}
    ;

TODOCLASE
    : TODOCLASE TODOCLASELISTA               {$1.push( { name: 'TODOCLASELISTA', children: $2 } ); $$ = $1;}
    | TODOCLASELISTA                         {$$=[{name: 'TODOCLASELISTA', children: $1}];}
    |                   //{$$=``;}
    ;

TODOCLASELISTA
    : VARIABLES                         {$$=[{name: 'VARIABLES', children: $1}];}
    | ASIGNACIONVAR                     {$$=[{name: 'ASIGNACIONVAR', children: $1}];}
    | FUNCIONES                         {$$=[{name: 'FUNCIONES', children: $1}];}
    | METODOS                           {$$=[{name: 'METODOS', children: $1}];}
    | MAIN                              {$$=[{name: 'MAIN', children: $1}];}
    ;

/*------------------------------------*
*                                     *
*_____________INTERFACE_______________*
*                                     *
*-------------------------------------*/
SINTAXISINTERFACE
    : tk_public tk_interface tk_identificador tk_llaa TODOINTERFACE tk_llac                             {$$=[{name: $1},{name: $2},{name: $3},{name: $4},{name: 'TODOINTERFACE', children: $5},{name: $6}];} 
    ;

TODOINTERFACE
    : TODOINTERFACE TODOINTERFACELISTA                                                                  {$1.push( { name: 'TODOINTERFACELISTA', children: $2 } ); $$ = $1;}
    | TODOINTERFACELISTA                                                                                {$$=[{name: 'TODOINTERFACELISTA', children: $1}];}
    |                                                                                                 
    //| TODOINTERFACE ERROR2 tk_puntocoma
    //| ERROR2 tk_puntocoma
    ;

TODOINTERFACELISTA
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_puntocoma                    {$$=[{name: $1},{name: 'TIPORETORNO', children: $2},{name: $3},{name: $4},{name: 'PARAMETROS', children: $5},{name: $6}];}
    ;


/*------------------------------------*
*                                     *
*______________VARIABLES______________*
*                                     *
*-------------------------------------*/
VARIABLES 
	: TIPO LISTAVARIABLES tk_puntocoma      {$$=[{name: 'TIPO', children: $1},{name: 'LISTAVARIABLES', children: $2}];}
    | ERROR2 tk_puntocoma                   //{$$=``;}
    ;

ASIGNACIONVAR
    : tk_identificador tk_igual EXP tk_puntocoma  {$$=[{name: $1},{name: $2},{name: 'EXP', children: $3}];}
    ;

LISTAVARIABLES 
	: SINTAXISVARIABLE                          {$$=[{name: 'SINTAXISVARIABLE', children: $1}];}
    | LISTAVARIABLES tk_coma SINTAXISVARIABLE   {$$=$1.push( { name: 'SINTAXISVARIABLE', children: $3 } ); $$ = $1;}
    ;
    
SINTAXISVARIABLE
    : tk_identificador tk_igual EXP     {$$=[{name: $1}, {name: $2}, {name: 'EXP', children: $3}];}
    | tk_identificador                  {$$=[{name: $1}];}
    ;


/*------------------------------------*
*                                     *
*________________MAIN_________________*
*                                     *
*-------------------------------------*/
MAIN
    : tk_public tk_static tk_void tk_main tk_para tk_String tk_cora tk_corc tk_identificador tk_parc tk_llaa INSTRUCCIONES tk_llac {$$=[{name: $1},{name: $2},{name: $3},{name: $4},{name: $5},{name: $6},{name: $7},{name: $8},{name: $9},{name: $10},{name: $11},{name: 'INSTRUCCIONES', children: $12},{name: $13}];}
    ;


/*------------------------------------*
*                                     *
*______________FUNCIONES______________*
*                                     *
*-------------------------------------*/
FUNCIONES
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_llaa INSTRUCCIONES tk_llac   {$$=[{name: $1},{name: 'TIPORETORNO', children: $2},{name: $3},{name: $4},{name: 'PARAMETROS', children: $5},{name: $6},{name: $7},{name: 'INSTRUCCIONES', children: $8},{name: $9}];}
    ;


/*------------------------------------*
*                                     *
*_______________METODOS_______________*
*                                     *
*-------------------------------------*/
METODOS
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_puntocoma {$$=[{name: $1},{name: 'TIPORETORNO', children: $2},{name: $3},{name: $4},{name: 'PARAMETROS', children: $5},{name: $6}];}
    ;


/*------------------------------------*
*                                     *
*________________TIPO_________________*
*                                     *
*-------------------------------------*/
TIPORETORNO
    : TIPO          {$$ = [{name: 'TIPO', children: $1}];}  
    | tk_void       {$$ = [{name: $1}];}  
    ;

TIPO
    : tk_int        {$$ = [{name: $1}];}  
    | tk_double     {$$ = [{name: $1}];}  
    | tk_boolean    {$$ = [{name: $1}];}  
    | tk_String     {$$ = [{name: $1}];}  
    | tk_char       {$$ = [{name: $1}];}   
    ;

/*------------------------------------*
*                                     *
*_____________PARAMETROS______________*
*                                     *
*-------------------------------------*/
PARAMETROS
    : TIPO tk_identificador                             {$$ = [{name: 'TIPO', children: $1},{name: $2}];}
    | PARAMETROS tk_coma TIPO tk_identificador          {$1.push({name: 'PARAMETROS', children: [{name: 'TIPO', children: $3},{name: $4}]}); $$=$1;}  //(?)
    |                                                   //{$$ = ``;}    
    ;

LISTAPARAMETROS
    : EXP                                               {$$ = [{name: 'EXP', children: $1}];}
    | LISTAPARAMETROS tk_coma EXP                       {$1.push({name: 'EXP', children: $3}); $$=$1;}
    ;

LISTAPARAMETROS2
    : EXP                                               {$$ = [{name: 'EXP', children: $1}];}
    | LISTAPARAMETROS2 tk_coma EXP                      {$1.push({name: 'EXP', children: $3}); $$=$1;}
    |                                                   //{$$ = ``;}
    ;

/*------------------------------------*
*                                     *
*___________INSTRUCCIONES_____________*
*                                     *
*-------------------------------------*/
INSTRUCCIONES
    : LISTAINSTRUCCIONES            {$$=[{name: 'LISTAINSTRUCCIONES', children: $1}];} 
    |                               //{}
    ;

LISTAINSTRUCCIONES
    : LISTAINSTRUCCIONES LISTAINSTRUCCIONESSINTAXIS         {$1.push({name: 'LISTAINSTRUCCIONESSINTAXIS', children: $2}); $$=$1;}
    | LISTAINSTRUCCIONESSINTAXIS                            {$$=[{name: 'LISTAINSTRUCCIONESSINTAXIS', children: $1}];}                            
    ;

LISTAINSTRUCCIONESSINTAXIS    
    : VARIABLES                                                                                             {$$=[{name: 'VARIABLES', children: $1}];}
    | ASIGNACIONVAR                                                                                         {$$=[{name: 'ASIGNACIONVAR', children: $1}];}
    | IF                                                                                                    {$$=[{name: 'IF', children: $1}];}
    | FOR                                                                                                   {$$=[{name: 'FOR', children: $1}];}
    | WHILE                                                                                                 {$$=[{name: 'WHILE', children: $1}];}
    | DOWHILE                                                                                               {$$=[{name: 'DOWHILE', children: $1}];}
    | tk_break tk_puntocoma                                                                                 {$$=[{name: $1}];}
    | tk_continue tk_puntocoma                                                                              {$$=[{name: $1}];}
    | tk_return EXP tk_puntocoma                                                                            {$$=[{name: 'return'}, {name: 'EXP', children: $2}];}
    | tk_return tk_puntocoma                                                                                {$$=[{name: $1}];}
    | tk_identificador tk_para LISTAPARAMETROS2 tk_parc tk_puntocoma                                        {$$=[{name: $1},{name: $2},{name: 'LISTAPARAMETROS2', children: $3},{name: $4}];}
    | tk_system tk_punto tk_out tk_punto tk_println tk_para PRINT tk_parc tk_puntocoma                      {$$=[{name: 'System'},{name:'out'},{name:'println'},{name:'('}, {name: 'PRINT', children: $7}, {name: ')'}];}
    | tk_system tk_punto tk_out tk_punto tk_print tk_para PRINT tk_parc tk_puntocoma                        {$$=[{name: 'System'},{name:'out'},{name:'printl'},{name:'('}, {name: 'PRINT', children: $7}, {name: ')'}];}
    | tk_identificador tk_mas tk_mas tk_puntocoma                                                           {$$=[{name: 'INCREMENTO', children: [{name: $1}, {name: '++'}]}];}
    | tk_identificador tk_menos tk_menos tk_puntocoma                                                       {$$=[{name: 'DECREMENTO', children: [{name: $1}, {name: '--'}]}];}
    ;

PRINT
    : EXP           {$$=[{name: 'EXP', children: $1}];}
    |               {}
    ;

/*------------------------------------*
*                                     *
*________________FOR__________________*
*                                     *
*-------------------------------------*/
FOR
    : tk_for tk_para DEC tk_puntocoma EXP tk_puntocoma EXP tk_parc tk_llaa INSTRUCCIONES tk_llac {$$=[{name: $1},{name: $2},{name: 'DEC', children: $3},{name: $4},{name: 'EXP', children: $5},{name: $6},{name: 'EXP', children: $7},{name: $8},{name: $9},{name: 'INSTRUCCIONES', children: $10},{name: $11}];}
    ;

/*------------------------------------*
*                                     *
*________________WHILE________________*
*                                     *
*-------------------------------------*/
WHILE
    : tk_while tk_para EXP tk_parc tk_llaa INSTRUCCIONES tk_llac            {$$=[{name: $1},{name: $2},{name: 'EXP', children: $3},{name: $4},{name: $5},{name: 'INSTRUCCIONES', children: $6},{name: $7}];}
    ;

/*------------------------------------*
*                                     *
*______________DO-WHILE_______________*
*                                     *
*-------------------------------------*/
DOWHILE
    : tk_do tk_llaa INSTRUCCIONES tk_llac tk_while tk_para EXP tk_parc tk_puntocoma             {$$=[{name: $1},{name: $2},{name: 'INSTRUCCIONES', children: $3},{name: $4},{name: $5},{name: $6},{name: 'EXP', children: $7},{name: $8},{name: $9}];}
    ;

/*------------------------------------*
*                                     *
*_________________IF__________________*
*                                     *
*-------------------------------------*/
IF
    : LISTAIF ELSE                                                      /*{$$=$1.push({name: 'ELSE', children: $2});}*/ {$$=[{name: 'LISTAIF', children: $1},{name: 'ELSE', children: $2}];}
    ;

LISTAIF
    : SINTAXISIF                                                        {$$=[{name: 'SINTAXISIF', children: $1}];}
    | LISTAIF tk_else SINTAXISIF                                        {$$=$1.push({name: 'else'}, {name: 'SINTAXISIF', children: $3}); $$ = $1;}
    ;

SINTAXISIF
    : tk_if tk_para EXP tk_parc tk_llaa INSTRUCCIONES tk_llac           {$$=[{name: $1},{name: $2},{name: 'EXP', children: $3},{name: $4},{name: $5},{name: 'INSTRUCCIONES', children: $6},{name: $7}];}
    ;

ELSE
    : tk_else tk_llaa INSTRUCCIONES tk_llac                             {$$=[{name: $1},{name: $2},{name: 'INSTRUCCIONES', children: $3},{name: $4}];}
    |
    ;

/*------------------------------------*
*                                     *
*____________DECLARACION______________*
*                                     *
*-------------------------------------*/
DEC
    : TIPO tk_identificador tk_igual EXP        {$$ = [{name: 'TIPO', children: $1}, {name: $2}, {name: '='}, {name: 'EXP', children: $4}];}
    | tk_identificador tk_igual EXP             {$$ = [{name: $1}, {name: '='}, {name: 'EXP', children: $3}];}
    | tk_identificador                          {$$ = [{name: $1}];}
    ;

/*------------------------------------*
*                                     *
*_____________EXPRESIONES_____________*
*                                     *
*-------------------------------------*/
EXP
    : EXP tk_and EXP                                        {$$ = [{name: 'EXP', children: $1}, {name: '&&'}, {name: 'EXP', children: $3}];}
    | EXP tk_or EXP                                         {$$ = [{name: 'EXP', children: $1}, {name: '||'}, {name: 'EXP', children: $3}];}
    | EXP tk_xor EXP                                        {$$ = [{name: 'EXP', children: $1}, {name: '^'}, {name: 'EXP', children: $3}];}
    | EXP tk_menorigual EXP	                                {$$ = [{name: 'EXP', children: $1}, {name: '<='}, {name: 'EXP', children: $3}];}
    | EXP tk_mayorigual EXP                                 {$$ = [{name: 'EXP', children: $1}, {name: '>='}, {name: 'EXP', children: $3}];}
    | EXP tk_dobleigual EXP                                 {$$ = [{name: 'EXP', children: $1}, {name: '=='}, {name: 'EXP', children: $3}];}
    | EXP tk_mas tk_mas                                     {$$ = [{name: 'EXP', children: $1}, {name: '++'}];}
    | EXP tk_menos tk_menos	                                {$$ = [{name: 'EXP', children: $1}, {name: '--'}];}
	| EXP tk_menorq EXP			                            {$$ = [{name: 'EXP', children: $1}, {name: '<'}, {name: 'EXP', children: $3}];}
    | EXP tk_mayorq EXP                                     {$$ = [{name: 'EXP', children: $1}, {name: '>'}, {name: 'EXP', children: $3}];}
    | EXP tk_diferente EXP	                                {$$ = [{name: 'EXP', children: $1}, {name: '!='}, {name: 'EXP', children: $3}];}
	| EXP tk_mas EXP                                        {$$ = [{name: 'EXP', children: $1}, {name: '+'}, {name: 'EXP', children: $3}];}
	| EXP tk_menos EXP                                      {$$ = [{name: 'EXP', children: $1}, {name: '-'}, {name: 'EXP', children: $3}];}
    | EXP tk_multi EXP                                      {$$ = [{name: 'EXP', children: $1}, {name: '*'}, {name: 'EXP', children: $3}];}
    | EXP tk_div EXP                                        {$$ = [{name: 'EXP', children: $1}, {name: '/'}, {name: 'EXP', children: $3}];}
    | tk_identificador tk_para LISTAPARAMETROS tk_parc      {$$ = [{name: $1}, {name:'('}, {name: 'LISTAPARAMETROS', children: $3}, {name: ')'}];}
    | tk_identificador tk_para tk_parc                      {$$ = [{name: $1}, {name: '('}, {name: ')'}];}
    | tk_not EXP                                            {$$ = [{name: '!'}, {name: 'EXP', children: $2}];}
	| tk_menos EXP %prec MENOSNUMERO                        {$$ = [{name: '-'}, {name: 'EXP', children: $2}];}
    | tk_para EXP tk_parc                                   {$$ = [{name: '('}, {name: 'EXP', children: $2}, {name: ')'}];}
	| VAL                                                   {$$ = [{name: 'VAL', children: $1}];}
    ;

/*------------------------------------*
*                                     *
*_______________VALORES_______________*
*                                     *
*-------------------------------------*/
VAL
    : tk_identificador      {$$ = [{name: $1}];}
    | tk_entero             {$$ = [{name: $1}];}
    | tk_decimal            {$$ = [{name: $1}];}
    | tk_cadena             {$$ = [{name: $1}];}
    | tk_cadenasimple       {$$ = [{name: $1}];}
    | tk_true               {$$ = [{name: 'true'}];}
    | tk_false              {$$ = [{name: 'false'}];}
    ;

/*------------------------------------*
*                                     *
*_______________ERROR_________________*
*                                     *
*-------------------------------------*/
ERROR
    : tk_error {console.log('error: '+yytext+ 'fila :'+this._$.first_line);}
    | EOF {return 'ERROR IRRECUPERABLE, F en el chat xD'}
    ;

ERROR2
    : error {console.log('error: '+yytext+ ' fila: '+this._$.first_line);}
    ;
