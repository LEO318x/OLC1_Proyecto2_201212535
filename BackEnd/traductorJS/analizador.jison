/* Importaciones  */
%{
let lisErrorLexico = [], lisErrorSintactico = [], lisTokens = [], lisTraduccion = [], auxComents = "";
exports.LimpiarListas = function(){
        lisErrorLexico = [];
        lisErrorSintactico = [];
        lisTokens = [];
        lisTraduccion = [];
        auxComents = "";
    }
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
"//".*  {auxComents += "\n" + yytext + "\n";}

//Comentario Multilínea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] {auxComents += "\n" + yytext + "\n";}

/***************************************
*                                      *
*---------->EXP. REGULARES<------------*
*                                      *
****************************************/
// Er. Cadena Comilla Doble         
[\"][^\\\"]*([\\][\\\"ntr][^\\\"]*)*[\"]        { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_cadena', yytext]); return 'tk_cadena'}

// Er. Cadena Comilla Simple
[\'][^\\\']*([\\][\\\'ntr][^\\\']*)*[']         { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_cadenasimple', yytext]); return 'tk_cadenasimple' }

// Er. Número decimal
[0-9]+(\.[0-9]+)\b                  { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_decimal', yytext]); return 'tk_decimal';}

// Er. Número entero
[0-9]+\b                            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_entero', yytext]); return 'tk_entero'; }
     

/***************************************
*                                      *
*-------->PALABRAS RESERVADAS<---------*
*                                      *
****************************************/

"public"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_public', yytext]); return 'tk_public'; }
"class"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_class', yytext]); return 'tk_class'; }
"interface"         { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_interface', yytext]); return 'tk_interface'; }
"void"              { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_void', yytext]); return 'tk_void'; }
"main"              { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_main', yytext]); return 'tk_main'; }
"static"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_static', yytext]); return 'tk_static'; }
"for"               { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_for', yytext]); return 'tk_for'; }
"while"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_while', yytext]); return 'tk_while'; }
"do"                { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_do', yytext]); return 'tk_do'; }
"if"                { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_if', yytext]); return 'tk_if'; }
"else"              { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_else', yytext]); return 'tk_else'; }
"int"               { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_int', yytext]); return 'tk_int'; }
"boolean"           { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_boolean', yytext]); return 'tk_boolean'; }
"double"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_double', yytext]); return 'tk_double'; }
"String"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_String', yytext]); return 'tk_String'; }
"char"              { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_char', yytext]); return 'tk_char'; }
"true"              { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_true', yytext]); return 'tk_true'; }
"false"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_false', yytext]); return 'tk_false'; }
"break"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_break', yytext]); return 'tk_break'; }
"continue"          { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_continue', yytext]); return 'tk_continue'; }
"return"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_return', yytext]); return 'tk_return'; }
"System"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_system', yytext]); return 'tk_system'; }
"out"               { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_out', yytext]); return 'tk_out'; }
"print"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_print', yytext]); return 'tk_print'; }
"println"           { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_println', yytext]); return 'tk_println'; }


/***************************************
*                                      *
*-------------->SIMBOLOS<--------------*
*                                      *
****************************************/

// Símbolos de apertura y cerradura
"("             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_para', yytext]); return 'tk_para'; }
")"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_parc', yytext]); return 'tk_parc'; }
"{"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_llaa', yytext]); return 'tk_llaa'; }
"}"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_llac', yytext]); return 'tk_llac'; }
"["             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_cora', yytext]); return 'tk_cora'; }
"]"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_corc', yytext]); return 'tk_corc'; }

// Lógicos
"&&"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_and', yytext]); return 'tk_and'; }
"||"            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_or', yytext]); return 'tk_or'; }
"^"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_xor', yytext]); return 'tk_xor'; }

// Relacionales
">="            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_mayorigual', yytext]); return 'tk_mayorigual'; }
"<="            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_menorigual', yytext]); return 'tk_menorigual'; }
"=="            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_dobleigual', yytext]); return 'tk_dobleigual'; }
"!="            { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_diferente', yytext]); return 'tk_diferente'; }
">"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_mayorq', yytext]); return 'tk_mayorq'; }
"<"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_menorq', yytext]); return 'tk_menorq'; }

// Lógicos
"!"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_not', yytext]); return 'tk_not'; }

// Operacionales
"+"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_mas', yytext]); return 'tk_mas'; }
"-"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_menos', yytext]); return 'tk_menos'; }
"*"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_multi', yytext]); return 'tk_multi'; }
"/"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_div', yytext]); return 'tk_div'; }

// Símbolos de separación
"="             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_igual', yytext]); return 'tk_igual'; }
"."             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_punto', yytext]); return 'tk_punto'; }
","             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_coma', yytext]); return 'tk_coma'; }
":"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_dospuntos', yytext]); return 'tk_dospuntos'; }
";"             { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_puntocoma', yytext]); return 'tk_puntocoma'; }

/***************************************
*                                      *
*---------->EXP. REGULARES 2<----------*
*                                      *
****************************************/


// Er. Identificador
([a-zA-Z_])[a-zA-Z0-9_]*                        { lisTokens.push([yylloc.first_line, yylloc.first_column+1, 'tk_identificador', yytext]); return 'tk_identificador'; }


//Fin del Archivo
<<EOF>>	        { return 'EOF'; } 


// Error Lexico
. {
    lisErrorLexico.push([yylloc.first_line, yylloc.first_column+1, yytext]); // Fila, Columna, Descripción
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
    : TODO EOF                     {/*console.log('----------------'); console.log(lisTokens); console.log('#----------------#');*/ return [{listaTokens: lisTokens}, {listaErroresLexicos: lisErrorLexico}, {listaErroresSintacticos: lisErrorSintactico}, {listaTraduccion: $1+auxComents}];} 
    ;

TODO
    : INSTRUCCIONESTODO                     {$$=`${$1}`;}
    |                                       {$$=``;}
    ;

INSTRUCCIONESTODO
    : LISTASINTAXIS                         {$$=`${$1}`;}
    | INSTRUCCIONESTODO LISTASINTAXIS       {$$=`${$1} ${$2}`;}
    ;

LISTASINTAXIS
    : SINTAXISCLASE                     {$$=`${$1}`;}
    | SINTAXISINTERFACE                 {$$=`${$1}`;}
    | ERROR2                            {$$=``;}
    ;

/*------------------------------------*
*                                     *
*________________CLASE________________*
*                                     *
*-------------------------------------*/
SINTAXISCLASE
    : tk_public tk_class tk_identificador tk_llaa TODOCLASE tk_llac {$$=`class ${$3}{\n${$5}\n}`;}
    | ERROR2 tk_llac                                                       {$$=``;}
    ;

TODOCLASE
    : TODOCLASELISTA                {$$=`${$1}`;}
    | TODOCLASE TODOCLASELISTA      {$$=`${$1} ${$2}`;}
    |                               {$$=``;}
    ;

TODOCLASELISTA
    : VARIABLES                         {$$=`${$1}`;}
    | ASIGNACIONVAR                     {$$=`${$1}`;}
    | FUNCIONES                         {$$=`${$1}`;}
    | METODOS                           //{$$=`${$1}`;}
    | MAIN                              {$$=`${$1}`;}
    ;

/*------------------------------------*
*                                     *
*_____________INTERFACE_______________*
*                                     *
*-------------------------------------*/
SINTAXISINTERFACE
    : tk_public tk_interface tk_identificador tk_llaa TODOINTERFACE tk_llac                             {$$=``;}
    ;

TODOINTERFACE
    : TODOINTERFACE TODOINTERFACELISTA                                                                  {$$=``;}
    | TODOINTERFACELISTA                                                                                {$$=``;}
    |                                                                                                 
    ;

TODOINTERFACELISTA
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_puntocoma                    {$$=``;}
    | ERROR2 tk_puntocoma                                                                               {$$=``;}
    ;


/*------------------------------------*
*                                     *
*______________VARIABLES______________*
*                                     *
*-------------------------------------*/
VARIABLES 
	: TIPO LISTAVARIABLES tk_puntocoma      {$$=`var ${$2}; \n`;}
    | ERROR2 tk_puntocoma                   {$$=``;}
    ;

ASIGNACIONVAR
    : tk_identificador tk_igual EXP tk_puntocoma  {$$=`${$1} = ${$3}; \n`;}
    ;

LISTAVARIABLES 
	: SINTAXISVARIABLE
    | LISTAVARIABLES tk_coma SINTAXISVARIABLE {$$=`${$1} , ${$3}`;}
    ;
    
SINTAXISVARIABLE
    : tk_identificador tk_igual EXP     {$$=`${$1} = ${$3}`;}
    | tk_identificador                  {$$=`${$1}`;}
    ;


/*------------------------------------*
*                                     *
*________________MAIN_________________*
*                                     *
*-------------------------------------*/
MAIN
    : tk_public tk_static tk_void tk_main tk_para tk_String tk_cora tk_corc tk_identificador tk_parc tk_llaa INSTRUCCIONES tk_llac {$$=`\nfunction main(${$9}){\n${$12}\n}`;}
    | ERROR2 tk_llac {$$=``;}
    ;


/*------------------------------------*
*                                     *
*______________FUNCIONES______________*
*                                     *
*-------------------------------------*/
FUNCIONES
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_llaa INSTRUCCIONES tk_llac   {$$=`\nfunction ${$3}(${$5}){\n${$8}\n}\n`;}
    ;


/*------------------------------------*
*                                     *
*_______________METODOS_______________*
*                                     *
*-------------------------------------*/
METODOS
    : tk_public TIPORETORNO tk_identificador tk_para PARAMETROS tk_parc tk_puntocoma //{$$=`${}`;}
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
    | tk_double
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
    : TIPO tk_identificador                             {$$ = `${$2}`;}
    | PARAMETROS tk_coma TIPO tk_identificador          {$$ = `${$1},${$4}`;}
    |                                                   {$$ = ``;}    
    ;

LISTAPARAMETROS
    : EXP                                               {$$ = `${$1}`;}
    | LISTAPARAMETROS tk_coma EXP                       {$$ = `${$1},${$3}`;}
    ;

LISTAPARAMETROS2
    : EXP                                               {$$ = `${$1}`;}
    | LISTAPARAMETROS2 tk_coma EXP                      {$$ = `${$1},${$3}`;}
    |                                                   {$$ = ``;}
    ;

/*------------------------------------*
*                                     *
*___________INSTRUCCIONES_____________*
*                                     *
*-------------------------------------*/
INSTRUCCIONES
    : LISTAINSTRUCCIONES            {$$=`${$1}`;} 
    |                               {$$=``;}
    ;

LISTAINSTRUCCIONES
    : LISTAINSTRUCCIONES LISTAINSTRUCCIONESSINTAXIS                                                         {$$ = `${$1} ${$2}`;}
    | LISTAINSTRUCCIONESSINTAXIS                                                                            {$$ = `${$1}`;}                        
    ;

LISTAINSTRUCCIONESSINTAXIS
    : VARIABLES                                                                                             {$$=`${$1}\n`;}
    | ASIGNACIONVAR                                                                                         {$$=`${$1}\n`;}
    | IF                                                                                                    {$$=`${$1}\n`;}
    | FOR                                                                                                   {$$=`${$1}\n`;}
    | WHILE                                                                                                 {$$=`${$1}\n`;}
    | DOWHILE                                                                                               {$$=`${$1}\n`;}
    | tk_break tk_puntocoma                                                                                 {$$=`${$1} ${$2};\n`;}
    | tk_continue tk_puntocoma                                                                              {$$=`${$1} ${$2};\n`;}
    | tk_return EXP tk_puntocoma                                                                            {$$=`${$1} ${$2};\n`;}
    | tk_identificador tk_para LISTAPARAMETROS2 tk_parc tk_puntocoma                                        {$$=`${$1} (${$3});\n`;}
    | tk_system tk_punto tk_out tk_punto tk_println tk_para PRINT tk_parc tk_puntocoma                      {$$=`console.log(${$7});\n`;}
    | tk_system tk_punto tk_out tk_punto tk_print tk_para PRINT tk_parc tk_puntocoma                        {$$=`console.log(${$7});\n`;}
    | tk_identificador tk_mas tk_mas tk_puntocoma                                                           {$$=`\n${$1}++;\n`;}
    | tk_identificador tk_menos tk_menos tk_puntocoma                                                       {$$=`\n${$1}--;\n`;}
    ;

PRINT
    : EXP           {$$=`${$1}`;}
    |               {$$=``;}
    ;

/*------------------------------------*
*                                     *
*________________FOR__________________*
*                                     *
*-------------------------------------*/
FOR
    : tk_for tk_para DEC tk_puntocoma EXP tk_puntocoma EXP tk_parc tk_llaa INSTRUCCIONES tk_llac {$$=`for (${$3} ; ${$5} ; ${$7}){\n${$10}\n}\n`;}
    ;

/*------------------------------------*
*                                     *
*________________WHILE________________*
*                                     *
*-------------------------------------*/
WHILE
    : tk_while tk_para EXP tk_parc tk_llaa INSTRUCCIONES tk_llac            {$$=`while(${$3}){\n${$6}\n}\n`;}
    ;

/*------------------------------------*
*                                     *
*______________DO-WHILE_______________*
*                                     *
*-------------------------------------*/
DOWHILE
    : tk_do tk_llaa INSTRUCCIONES tk_llac tk_while tk_para EXP tk_parc tk_puntocoma             {$$=`do{\n${$3}\n}while(${$7});`;}
    ;

/*------------------------------------*
*                                     *
*_________________IF__________________*
*                                     *
*-------------------------------------*/
IF
    : LISTAIF ELSE                                                      {$$=`${$1} ${$2}`;}
    ;

LISTAIF
    : SINTAXISIF                                                        {$$=`${$1}`;}
    | LISTAIF tk_else SINTAXISIF                                        {$$=`${$1}else ${$3}`;}
    ;

SINTAXISIF
    : tk_if tk_para EXP tk_parc tk_llaa INSTRUCCIONES tk_llac           {$$=`if(${$3}){\n${$6}\n}`;}
    ;

ELSE
    : tk_else tk_llaa INSTRUCCIONES tk_llac                             {$$=`else{\n${$3}\n}\n`;}
    |
    ;

/*------------------------------------*
*                                     *
*____________DECLARACION______________*
*                                     *
*-------------------------------------*/
DEC
    : TIPO tk_identificador tk_igual EXP        {$$ = `var ${$2} = ${$4}`;}
    | tk_identificador tk_igual EXP             {$$ = `${$1} = ${$3}`;}
    | tk_identificador                          {$$ = `${$1}`;}
    ;

/*------------------------------------*
*                                     *
*_____________EXPRESIONES_____________*
*                                     *
*-------------------------------------*/
EXP
    : EXP tk_and EXP                                        {$$ = `${$1} && ${$3}`; }
    | EXP tk_or EXP                                         {$$ = `${$1} || ${$3}`;}
    | EXP tk_xor EXP                                        {$$ = `${$1} ^ ${$3}`;}
    | EXP tk_menorigual EXP	                                {$$ = `${$1} <= ${$3}`;}
    | EXP tk_mayorigual EXP                                 {$$ = `${$1} >= ${$3}`;}
    | EXP tk_dobleigual EXP                                 {$$ = `${$1} == ${$3}`;}
    | EXP tk_mas tk_mas                                     {$$ = `${$1}++`;}
    | EXP tk_menos tk_menos	                                {$$ = `${$1}--`;}
	| EXP tk_menorq EXP			                            {$$ = `${$1} < ${$3}`;}
    | EXP tk_mayorq EXP                                     {$$ = `${$1} > ${$3}`;}
    | EXP tk_diferente EXP	                                {$$ = `${$1} != ${$3}`;}
	| EXP tk_mas EXP                                        {$$ = `${$1} + ${$3}`;}
	| EXP tk_menos EXP                                      {$$ = `${$1} - ${$3}`;}
    | EXP tk_multi EXP                                      {$$ = `${$1} * ${$3}`;}
    | EXP tk_div EXP                                        {$$ = `${$1} / ${$3}`;}
    | tk_identificador tk_para LISTAPARAMETROS tk_parc      {$$ = `${$1}(${$3})`;}
    | tk_identificador tk_para tk_parc                      {$$ = `${$1}()`;}
    | tk_not EXP                                            {$$ = `!${$2}`;}
	| tk_menos EXP %prec MENOSNUMERO                        {$$ = `-${$2}`;}
    | tk_para EXP tk_parc                                   {$$ = `(${$2})`;}
	| VAL                                                   {$$ = `${$1}`;}
    ;

/*------------------------------------*
*                                     *
*_______________VALORES_______________*
*                                     *
*-------------------------------------*/
VAL
    : tk_identificador      {$$ = `${$1}`; }
    | tk_entero             {$$ = `${$1}`; }
    | tk_decimal            {$$ = `${$1}`; }
    | tk_cadena             {$$ = `${$1}`; }
    | tk_cadenasimple       {$$ = `${$1}`; }
    | tk_true               {$$ = `true` ; }
    | tk_false              {$$ = `false`; }
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
    : error {lisErrorSintactico.push([this._$.first_line, this.first_column+1, yytext]); console.log('error: '+yytext+ ' fila: '+this._$.first_line);} //Fila, Columna, Descripción
    ;
