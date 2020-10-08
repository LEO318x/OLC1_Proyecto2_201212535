/* Importaciones  */
%{
// CODIGO JS
var lisErrorLexico = [];
var lisErrorSintactico = [];
var lisTokens[];
var lisTraduccion[];
%}

/* Analizador Lexico */
%lex
%options case-sensitive 

%%

/***************************************
*                                      *
*------------>COMENTARIOS<-------------*
*                                      *
****************************************/

//Comentario Unilínea
\/\/.* //{ return 'tk_comentario'; }

//Comentario Multilínea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] //{ return 'tk_comentariomulti'; }

/***************************************
*                                      *
*---------->EXP. REGULARES<------------*
*                                      *
****************************************/


// Er. Número decimal
[0-9]+(\.[0-9]+)\b                  { return 'tk_decimal'; }

// Er. Número entero
[0-9]+\b                            { return 'tk_entero'; }

// Er. Cadena Comilla Doble         
\".*\"                              { return 'tk_cadena'}

// Er. Cadena Comilla Simple
\'.*\'                              { return 'tk_cadenasimple' }
	      

/***************************************
*                                      *
*-------->PALABRAS RESERVADAS<---------*
*                                      *
****************************************/

"public"            { return 'tk_public'; }
"class"             { return 'tk_class'; }
"interface"         { return 'tk_interface'; }
"void"              { return 'tk_void'; }
"main"              { return 'tk_main'; }
"static"            { return 'tk_static'; }
"for"               { return 'tk_for'; }
"while"             { return 'tk_while'; }
"do"                { return 'tk_do'; }
"if"                { return 'tk_if'; }
"else"              { return 'tk_else'; }
"int"               { return 'tk_int'; }
"boolean"           { return 'tk_boolean'; }
"double"            { return 'tk_double'; }
"String"            { return 'tk_String'; }
"char"              { return 'tk_char'; }
"true"              { return 'tk_true'; }
"false"             { return 'tk_false'; }
"break"             { return 'tk_break'; }
"continue"          { return 'tk_continue'; }
"return"            { return 'tk_return'; }
"System"            { return 'tk_system'; }
"out"               { return 'tk_out'; }
"print"             { return 'tk_print'; }
"println"           { return 'tk_println'; }


/***************************************
*                                      *
*-------------->SIMBOLOS<--------------*
*                                      *
****************************************/

// Símbolos de apertura y cerradura
"("             { return 'tk_para'; }
")"             { return 'tk_parc'; }
"{"             { return 'tk_llaa'; }
"}"             { return 'tk_llac'; }
"["             { return 'tk_cora'; }
"]"             { return 'tk_corc'; }

// Lógicos
"&&"            { return 'tk_and'; }
"||"            { return 'tk_or'; }
"!"             { return 'tk_not'; }
"^"             { return 'tk_xor'; }

// Relacionales
">="            { return 'tk_mayorigual'; }
"<="            { return 'tk_menorigual'; }
"=="            { return 'tk_dobleigual'; }
"!="            { return 'tk_diferente'; }
">"             { return 'tk_mayorq'; }
"<"             { return 'tk_menorq'; }


// Operacionales
"++"            { return 'tk_incremento'; }
"--"            { return 'tk_decremento'; }
"+"             { return 'tk_mas'; }
"-"             { return 'tk_menos'; }
"*"             { return 'tk_multi'; }
"/"             { return 'tk_div'; }

// Símbolos de separación
"="             { return 'tk_igual'; }
"."             { return 'tk_punto'; }
","             { return 'tk_coma'; }
":"             { return 'tk_dospuntos'; }
";"             { return 'tk_puntocoma'; }

/***************************************
*                                      *
*---------->EXP. REGULARES 2<----------*
*                                      *
****************************************/


// Er. Identificador
([a-zA-Z_])[a-zA-Z0-9_]*            { return 'tk_identificador'; }

// Er. Espacios en blanco
\s+                                 {  }


//Fin del Archivo
<<EOF>>	        { return 'EOF'; } 


// Error Lexico
. {
    lisErrorLexico.push(["Fila: "+yylloc.first_line, "Columna: "+yylloc.first_column, "Descripcion: "+yytext]); 
    //console.log('Error Lexico token:' + yytext + ' fila:' + yylloc.first_line + ' columna:' + yylloc.first_column); 
    //console.log(yylloc);
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

// Incremento, Decremento
%left 'tk_incremento' 'tk_decremento'

// Operaciones Aritméticas
%left 'tk_mas' 'tk_menos'
%left 'tk_multi' 'tk_div'

// Negación y Menos de número Negativo
%left 'tk_not' 'tk_menosnumero'

// Return
%left 'tk_return'

%start INICIO

%%
INICIO
    : TODO EOF                     {  } 
    ;

TODO
    : INSTRUCCIONESTODO
    |
    ;

INSTRUCCIONESTODO
    : LISTASINTAXIS
    | INSTRUCCIONESTODO LISTASINTAXIS
    ;

LISTASINTAXIS
    : SINTAXISCLASE
    | SINTAXISINTERFACE
    | ERROR2
    ;

/*------------------------------------*
*                                     *
*________________CLASE________________*
*                                     *
*-------------------------------------*/
SINTAXISCLASE
    : tk_public tk_class tk_identificador tk_llaa TODOCLASE tk_llac {console.log($1+' '+$2+' '+$3+' '+$4+' '+$6);}
    ;

TODOCLASE
    : TODOCLASELISTA
    |
    ;

TODOCLASELISTA
    : TODOCLASELISTA VARIABLES
    | TODOCLASELISTA ASIGNACIONVAR
    | TODOCLASELISTA FUNCIONES
    | TODOCLASELISTA METODOS
    | VARIABLES
    | ASIGNACIONVAR
    | FUNCIONES
    | METODOS
    | MAIN
    ;

/*------------------------------------*
*                                     *
*_____________INTERFACE_______________*
*                                     *
*-------------------------------------*/
SINTAXISINTERFACE
    : tk_public tk_interface tk_identificador tk_llaa TODOINTERFACE tk_llac {console.log($1+' '+$2+' '+$3+' '+$4+' '+$5+' '+$6);}
    ;

TODOINTERFACE
    : TODOINTERFACE tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_puntocoma {$$ = $2+' '+$3+' '+$4+' '+$5+' '+$7+' '+$8;}
    | tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_puntocoma {$$ = $2+' '+$3+' '+$4+' '+$5+' '+$7+' '+$8;}
    | TODOINTERFACE ERROR2 tk_puntocoma
    | ERROR2 tk_puntocoma
    ;


/*------------------------------------*
*                                     *
*______________VARIABLES______________*
*                                     *
*-------------------------------------*/
VARIABLES 
	: TIPO LISTAVARIABLES tk_puntocoma
    | ERROR2 tk_puntocoma
    ;

ASIGNACIONVAR
    : tk_identificador tk_igual EXP tk_puntocoma
    ;

LISTAVARIABLES 
	: SINTAXISVARIABLE
    | LISTAVARIABLES tk_coma SINTAXISVARIABLE
    ;
    
SINTAXISVARIABLE
    : tk_identificador tk_igual EXP
    | tk_identificador
    ;


/*------------------------------------*
*                                     *
*________________MAIN_________________*
*                                     *
*-------------------------------------*/
MAIN
    : tk_public tk_static tk_void tk_main tk_para tk_String tk_cora tk_corc tk_identificador tk_parc tk_llaa INSTRUCCIONES tk_llac
    ;


/*------------------------------------*
*                                     *
*______________FUNCIONES______________*
*                                     *
*-------------------------------------*/
FUNCIONES
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_llaa INSTRUCCIONES tk_llac
    ;


/*------------------------------------*
*                                     *
*_______________METODOS_______________*
*                                     *
*-------------------------------------*/
METODOS
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_puntocoma
    ;


/*------------------------------------*
*                                     *
*________________TIPO_________________*
*                                     *
*-------------------------------------*/
TIPORETORNO
    : TIPO
    | tk_void
    ;

TIPO
    : tk_int
    | tk_boolean
    | tk_String
    | tk_char
    ;

/*------------------------------------*
*                                     *
*_____________PARAMETROS______________*
*                                     *
*-------------------------------------*/
PARAMETROS
    : TIPO tk_identificador
    | PARAMETROS tk_coma TIPO tk_identificador
    |    
    ;

LISTAPARAMETROS
    : EXP
    | LISTAPARAMETROS tk_coma EXP
    ;

LISTAPARAMETROS2
    : EXP
    | LISTAPARAMETROS2 tk_coma EXP
    |
    ;

/*------------------------------------*
*                                     *
*___________INSTRUCCIONES_____________*
*                                     *
*-------------------------------------*/
INSTRUCCIONES
    : LISTAINSTRUCCIONES 
    |
    ;

LISTAINSTRUCCIONES
    : LISTAINSTRUCCIONES VARIABLES 
    | LISTAINSTRUCCIONES ASIGNACIONVAR
    | LISTAINSTRUCCIONES IF
    | LISTAINSTRUCCIONES FOR
    | LISTAINSTRUCCIONES WHILE
    | LISTAINSTRUCCIONES DOWHILE
    | LISTAINSTRUCCIONES tk_system tk_punto tk_out tk_punto tk_println tk_para PRINT tk_parc tk_puntocoma
    | LISTAINSTRUCCIONES tk_system tk_punto tk_out tk_punto tk_print tk_para PRINT tk_parc tk_puntocoma
    | LISTAINSTRUCCIONES tk_break tk_puntocoma
    | LISTAINSTRUCCIONES tk_continue tk_puntocoma
    | LISTAINSTRUCCIONES tk_return EXP tk_puntocoma
    | LISTAINSTRUCCIONES tk_identificador tk_para LISTAPARAMETROS2 tk_parc tk_puntocoma
    | VARIABLES
    | ASIGNACIONVAR
    | IF
    | FOR
    | WHILE
    | DOWHILE
    | tk_break tk_puntocoma
    | tk_continue tk_puntocoma
    | tk_return EXP tk_puntocoma
    | tk_identificador tk_para LISTAPARAMETROS2 tk_parc tk_puntocoma
    | tk_system tk_punto tk_out tk_punto tk_println tk_para PRINT tk_parc tk_puntocoma
    | tk_system tk_punto tk_out tk_punto tk_print tk_para PRINT tk_parc tk_puntocoma
    ;

PRINT
    : EXP
    |
    ;

/*------------------------------------*
*                                     *
*________________FOR__________________*
*                                     *
*-------------------------------------*/
FOR
    : tk_for tk_para DEC tk_puntocoma EXP tk_puntocoma EXP tk_parc tk_llaa INSTRUCCIONES tk_llac
    ;

/*------------------------------------*
*                                     *
*________________WHILE________________*
*                                     *
*-------------------------------------*/
WHILE
    : tk_while tk_para EXP tk_parc tk_llaa INSTRUCCIONES tk_llac
    ;

/*------------------------------------*
*                                     *
*______________DO-WHILE_______________*
*                                     *
*-------------------------------------*/
DOWHILE
    : tk_llaa INSTRUCCIONES tk_llac tk_while tk_para EXP tk_parc tk_puntocoma
    ;

/*------------------------------------*
*                                     *
*_________________IF__________________*
*                                     *
*-------------------------------------*/
IF
    : LISTAIF ELSE
    ;

LISTAIF
    : SINTAXISIF
    | LISTAIF tk_else SINTAXISIF
    ;

SINTAXISIF
    : tk_if tk_para EXP tk_parc tk_llaa INSTRUCCIONES tk_llac
    ;

ELSE
    : tk_else tk_llaa INSTRUCCIONES tk_llac
    |
    ;

/*------------------------------------*
*                                     *
*____________DECLARACION______________*
*                                     *
*-------------------------------------*/
DEC
    : TIPO tk_identificador tk_igual EXP
    | tk_identificador tk_igual EXP
    | tk_identificador
    ;

/*------------------------------------*
*                                     *
*_____________EXPRESIONES_____________*
*                                     *
*-------------------------------------*/
EXP
    : EXP tk_and EXP
    | EXP tk_or EXP
    | EXP tk_xor EXP
	| EXP tk_menorq EXP			
    | EXP tk_mayorq EXP	
    | EXP tk_menorigual EXP	
    | EXP tk_mayorigual EXP	
    | EXP tk_dobleigual EXP
    | EXP tk_diferente EXP	
	| EXP tk_mas EXP
	| EXP tk_menos EXP
    | EXP tk_multi EXP
    | EXP tk_div EXP
    | tk_identificador tk_para LISTAPARAMETROS tk_parc
    | tk_identificador tk_para tk_parc
    | tk_not EXP
    | tk_identificador tk_incremento 
    | tk_identificador tk_decremento
	| tk_menos EXP %prec tk_menosnumero
    | tk_para EXP tk_parc
	| VAL
    ;

/*------------------------------------*
*                                     *
*_______________VALORES_______________*
*                                     *
*-------------------------------------*/
VAL
    : tk_identificador
    | tk_entero
    | tk_decimal
    | tk_cadena
    | tk_true
    | tk_false
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
