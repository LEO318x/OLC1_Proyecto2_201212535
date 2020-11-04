class parser{
    constructor(listaTokens) {
        this.listaTokens = listaTokens;
        this.columna = 1;
        this.listaLexemas = [];
        this.tamanioLista = listaTokens.length;
        this.pos = 0;
        this.tokenPreanalisis = listaTokens[0][0];
        console.log(this.listaTokens);
    }

    parea(token){

            if(token != this.tokenPreanalisis){
                console.log('error '+ token + ' pre ' + this.tokenPreanalisis);
            }
            if(this.pos < this.tamanioLista){
                console.log(token + '<--->' + this.tokenPreanalisis + ' <---> ' + this.listaTokens[this.pos][1]);
                this.pos++;
                this.tokenPreanalisis = this.listaTokens[this.pos][0];
            }        
    }

    inicio(){
        this.TODO();
    }

    TODO(){
        this.INSTRUCCIONESTODO();
        //e
    }

    INSTRUCCIONESTODO(){
        this.LISTASINTAXIS();
        this.INSTRUCCIONESTODOP();
    }

    INSTRUCCIONESTODOP(){
        this.LISTASINTAXIS();
        this.INSTRUCCIONESTODOP();
    }

    LISTASINTAXIS(){
        this.SINTAXISCLASEINTERFACE();
    }

    SINTAXISCLASEINTERFACE(){
        this.parea('tkPublic');
        if(this.listaTokens[this.pos][0] == 'tkClass'){
            this.parea('tkClass');
            this.parea('tkIdentificador');
            this.parea('tkLlaAbierta');
            this.TODOCLASE();
            this.parea('tkLlaCerrada');
        }else if(this.listaTokens[this.pos][0] == 'tkInterface'){
            this.parea('tkInterface');
            this.parea('tkIdentificador');
            this.parea('tkLlaAbierta');
            this.TODOINTERFACE();
            this.parea('tkLlaCerrada');
        }        
        
    }

    TODOCLASE(){
        this.TODOCLASELISTA();
        this.TODOCLASEP();
    }

    TODOCLASEP(){
        if(this.listaTokens[this.pos][0] == 'tkInt'
        || this.listaTokens[this.pos][0] == 'tkString'
        || this.listaTokens[this.pos][0] == 'tkDouble'
        || this.listaTokens[this.pos][0] == 'tkChar'
        || this.listaTokens[this.pos][0] == 'tkBoolean'
        || this.listaTokens[this.pos][0] == 'tkPublic'
        || this.listaTokens[this.pos][0] == 'tkIdentificador'
        ){ //agregar los demás
            this.TODOCLASELISTA();
            this.TODOCLASEP();
        }
        
    }

    TODOCLASELISTA(){
        if(this.listaTokens[this.pos][0] == 'tkInt'
        || this.listaTokens[this.pos][0] == 'tkString'
        || this.listaTokens[this.pos][0] == 'tkDouble'
        || this.listaTokens[this.pos][0] == 'tkChar'
        || this.listaTokens[this.pos][0] == 'tkBoolean'){
            this.VARIABLES();
        }

        if(this.listaTokens[this.pos][0] == 'tkIdentificador'){
            this.ASIGNACIONVAR();
        }

        if(this.listaTokens[this.pos][0] == 'tkPublic'){
            this.parea('tkPublic');

            if(this.listaTokens[this.pos][0] == 'tkStatic'){
                this.parea('tkStatic');
                this.MAIN();
            }
            
            if(this.listaTokens[this.pos][0] == 'tkInt'
            || this.listaTokens[this.pos][0] == 'tkString'
            || this.listaTokens[this.pos][0] == 'tkDouble'
            || this.listaTokens[this.pos][0] == 'tkChar'
            || this.listaTokens[this.pos][0] == 'tkBoolean'
            || this.listaTokens[this.pos][0] == 'tkVoid'){
                this.TIPORETORNO();
                if(this.listaTokens[this.pos][0] == 'tkIdentificador'){
                    this.parea('tkIdentificador');
                    this.FUNCIONESMETODOS();
                }
            }   
        }  
    }
    TODOINTERFACE(){
        this.TODOINTERFACELISTA();
        this.TODOINTERFACEP();
    }

    TODOINTERFACEP(){        
        if(this.listaTokens[this.pos][0] == 'tkPublic'){
            this.TODOINTERFACELISTA();
            this.TODOINTERFACEP();
        }

    }

    TODOINTERFACELISTA(){
        this.parea('tkPublic');
        this.TIPORETORNO();
        this.parea('tkIdentificador');
        this.parea('tkParAbierta');
        this.PARAMETROS();
        this.parea('tkParCerrada');
        this.parea('tkPuntoComa');
    }

/*------------------------------------*
*                                     *
*______________VARIABLES______________*
*                                     *
*-------------------------------------*/
    VARIABLES(){
        this.TIPO();
        this.LISTAVARIABLES();
        this.parea('tkPuntoComa');
    }

    ASIGNACIONVAR(){
            this.parea('tkIdentificador');
            this.parea('tkIgual');
            this.EXP();
            this.parea('tkPuntoComa');        
    }

    LISTAVARIABLES(){
        this.SINTAXISVARIABLE();
        this.LISTAVARIABLESP();
    }

    LISTAVARIABLESP(){
        if(this.listaTokens[this.pos][0] == 'tkIdentificador'){
            this.SINTAXISVARIABLE()
            this.parea('tkComa');
            this.LISTAVARIABLESP();
        }else if(this.listaTokens[this.pos][0] == 'tkComa'){
            this.parea('tkComa');
            this.SINTAXISVARIABLE()
            this.LISTAVARIABLESP();
        }
    }

    SINTAXISVARIABLE(){
        this.parea('tkIdentificador');
        if(this.listaTokens[this.pos][0] == 'tkIgual'){
            this.parea('tkIgual');
            this.EXP();
        }
    }

/*------------------------------------*
*                                     *
*________________MAIN_________________*
*                                     *
*-------------------------------------*/
    MAIN(){
        this.parea('tkVoid');
        this.parea('tkMain');
        this.parea('tkParAbierta');
        this.parea('tkString');
        this.parea('tkCorAbierta');
        this.parea('tkCorCerrada');
        this.parea('tkIdentificador');
        this.parea('tkParCerrada');
        this.parea('tkLlaAbierta');
        this.INSTRUCCIONES();
        this.parea('tkLlaCerrada');
    }

/*------------------------------------*
*                                     *
*__________FUNCIONES/METODOS__________*
*                                     *
*-------------------------------------*/

    FUNCIONESMETODOS(){
        this.parea('tkParAbierta');
        this.PARAMETROS();
        this.parea('tkParCerrada');
        if(this.listaTokens[this.pos][0] == 'tkLlaAbierta'){
            this.parea('tkLlaAbierta');
            this.INSTRUCCIONES();
            this.parea('tkLlaCerrada');
        }
        if(this.listaTokens[this.pos][0] == 'tkPuntoComa'){
            this.parea('tkPuntoComa');
        }
        
    }

/*------------------------------------*
*                                     *
*________________TIPO_________________*
*                                     *
*-------------------------------------*/

    TIPORETORNO(){
        if(this.listaTokens[this.pos][0] == 'tkVoid'){
            this.parea('tkVoid');
        }else{
            this.TIPO();
        }
    }

    TIPO(){
        switch (this.listaTokens[this.pos][0]) {
            case 'tkInt':
                this.parea('tkInt');
                break;
            case 'tkDouble':
                this.parea('tkDouble');
                break;
            case 'tkBoolean':
                this.parea('tkBoolean');
                break;
            case 'tkString':
                this.parea('tkString');
                break;
            case 'tkChar':
                this.parea('tkChar');
                break;        
            default:
                break;
        }
    }

/*------------------------------------*
*                                     *
*_____________PARAMETROS______________*
*                                     *
*-------------------------------------*/

    PARAMETROS(){
        if(this.listaTokens[this.pos][0] == 'tkInt'
            || this.listaTokens[this.pos][0] == 'tkString'
            || this.listaTokens[this.pos][0] == 'tkDouble'
            || this.listaTokens[this.pos][0] == 'tkChar'
            || this.listaTokens[this.pos][0] == 'tkBoolean'
            || this.listaTokens[this.pos][0] == 'tkVoid'){
                this.TIPO();
                this.parea('tkIdentificador');
                this.PARAMETROSP();
            }
        
    }

    PARAMETROSP(){
        if(this.listaTokens[this.pos][0] == 'tkComa'){
            this.parea('tkComa');
            this.TIPO();
            this.parea('tkIdentificador');
            this.PARAMETROSP();
        }
        
    }

    LISTAPARAMETROS(){
        this.EXP();
        this.LISTAPARAMETROSP();
    }

    LISTAPARAMETROSP(){
        if(this.listaTokens[this.pos][0] == 'tkComa'){
            this.parea('tkComa');
            this.EXP();
            this.LISTAPARAMETROSP();
        }
    }

    LISTAPARAMETROS2(){
        this.EXP();
        LISTAPARAMETROS2P();
    }

    LISTAPARAMETROS2P(){
        if(this.listaTokens[this.pos][0] == 'tkComa'){
            this.parea('tkComa');
            this.EXP();
            this.LISTAPARAMETROS2P();
        }
    }

/*------------------------------------*
*                                     *
*___________INSTRUCCIONES_____________*
*                                     *
*-------------------------------------*/    
    INSTRUCCIONES(){
        this.LISTAINSTRUCCIONES();
    }

    LISTAINSTRUCCIONES(){
        this.LISTAINSTRUCCIONESSINTAXIS();
        this.LISTAINSTRUCCIONESP();
    }

    LISTAINSTRUCCIONESP(){
        if(this.listaTokens[this.pos][0] == 'tkInt'
        || this.listaTokens[this.pos][0] == 'tkString'
        || this.listaTokens[this.pos][0] == 'tkDouble'
        || this.listaTokens[this.pos][0] == 'tkChar'
        || this.listaTokens[this.pos][0] == 'tkBoolean'
        || this.listaTokens[this.pos][0] == 'tkIdentificador'
        || this.listaTokens[this.pos][0] == 'tkIf'
        || this.listaTokens[this.pos][0] == 'tkFor'
        || this.listaTokens[this.pos][0] == 'tkWhile'
        || this.listaTokens[this.pos][0] == 'tkDo'
        || this.listaTokens[this.pos][0] == 'tkBreak'
        || this.listaTokens[this.pos][0] == 'tkContinue'
        || this.listaTokens[this.pos][0] == 'tkReturn'
        || this.listaTokens[this.pos][0] == 'tkSystem'){
            this.LISTAINSTRUCCIONESSINTAXIS();
            this.LISTAINSTRUCCIONESP();
        }
        
    }

    LISTAINSTRUCCIONESSINTAXIS(){
        if(this.listaTokens[this.pos][0] == 'tkInt'
        || this.listaTokens[this.pos][0] == 'tkString'
        || this.listaTokens[this.pos][0] == 'tkDouble'
        || this.listaTokens[this.pos][0] == 'tkChar'
        || this.listaTokens[this.pos][0] == 'tkBoolean'){
            this.VARIABLES();
        }

        if(this.listaTokens[this.pos][0] == 'tkIdentificador'){
            if(this.listaTokens[this.pos+1][0] == 'tkIgual'){
                this.ASIGNACIONVAR();
            }else{
                this.parea('tkIdentificador');
                if(this.listaTokens[this.pos][0] == 'tkParAbierta'){
                    this.parea('tkParAbierta');
                    this.LISTAPARAMETROS2();
                    this.parea('tkParCerrada');
                }else if(this.listaTokens[this.pos][0] == 'tkMas' ){
                    this.parea('tkMas');
                    this.parea('tkMas');
                }else if(this.listaTokens[this.pos][0] == 'tkMenos'){
                    this.parea('tkMenos');
                    this.parea('tkMenos');
                }            
                this.parea('tkPuntoComa');
            }
        }

        if(this.listaTokens[this.pos][0] == 'tkIf'){
            this.IF();
        }
        if(this.listaTokens[this.pos][0] == 'tkFor'){
            this.FOR();
        }
        if(this.listaTokens[this.pos][0] == 'tkWhile'){
            this.WHILE();
        }
        if(this.listaTokens[this.pos][0] == 'tkDo'){
            this.DOWHILE();
        }
        if(this.listaTokens[this.pos][0] == 'tkBreak'){
            this.parea('tkBreak');
            this.parea('tkPuntoComa');
        }
        if(this.listaTokens[this.pos][0] == 'tkContinue'){
            this.parea('tkContinue');
            this.parea('tkPuntoComa');
        }
        if(this.listaTokens[this.pos][0] == 'tkReturn'){
            this.parea('tkReturn');
            this.EXP();
            this.parea('tkPuntoComa');
        }

        if(this.listaTokens[this.pos][0] == 'tkSystem'){
            this.parea('tkSystem');
            this.parea('tkPunto');
            this.parea('tkOut');
            this.parea('tkPunto');
            if(this.listaTokens[this.pos][0] == 'tkPrintln'){
                this.parea('tkPrintln');
            }else if(this.listaTokens[this.pos][0] == 'tkPrint'){
                this.parea('tkPrint');
            }
            this.parea('tkParAbierta');
            this.PRINT();
            this.parea('tkParCerrada');
            this.parea('tkPuntoComa')
        }
    }

    PRINT(){
        this.EXP();
    }

/*------------------------------------*
*                                     *
*________________FOR__________________*
*                                     *
*-------------------------------------*/
    FOR(){
        this.parea('tkFor');
        this.parea('tkParAbierta');
        this.DEC();
        this.parea('tkPuntoComa');
        this.EXP();
        this.parea('tkPuntoComa');
        this.EXP();
        this.parea('tkParCerrada');
        this.parea('tkLlaAbierta');
        this.INSTRUCCIONES();
        this.parea('tkLlaCerrada');
    }

/*------------------------------------*
*                                     *
*________________WHILE________________*
*                                     *
*-------------------------------------*/
    WHILE(){
        this.parea('tkWhile');
        this.parea('tkParAbierta');
        this.EXP();
        this.parea('tkParCerrada');
        this.parea('tkLlaAbierta');
        this.INSTRUCCIONES();
        this.parea('tkParCerrada');
    }

/*------------------------------------*
*                                     *
*______________DO-WHILE_______________*
*                                     *
*-------------------------------------*/
    DOWHILE(){
        this.parea('tkDo');
        this.parea('tkLlaAbierta');
        this.INSTRUCCIONES();
        this.parea('tkLlaCerrada');
        this.parea('tkWhile');
        this.parea('tkParAbierta');
        this.EXP();
        this.parea('tkParCerrada');
        this.parea('tkPuntoComa');
    }

/*------------------------------------*
*                                     *
*_________________IF__________________*
*                                     *
*-------------------------------------*/
    IF(){
        this.LISTAIF(); 
        this.ELSE();
    }

    LISTAIF(){
        this.SINTAXISIF();
        this.LISTAIFP();
    }

    LISTAIFP(){
        if(this.listaTokens[this.pos][0] == 'tkElse'){
            this.parea('tkElse');
            this.SINTAXISIF();
            this.LISTAIFP();
        }     
    }

    SINTAXISIF(){
        this.parea('tkIf');
        this.parea('tkParAbierta');
        this.EXP();
        this.parea('tkParCerrada');
        this.parea('tkLlaAbierta');
        this.INSTRUCCIONES();
        this.parea('tkLlaCerrada');
    }

    ELSE(){
        if(this.listaTokens[this.pos][0] == 'tkElse'){
            this.parea('tkElse');
            this.parea('tkLlaAbierta');
            this.INSTRUCCIONES();
            this.parea('tkLlaCerrada');
        }        
    }

/*------------------------------------*
*                                     *
*____________DECLARACION______________*
*                                     *
*-------------------------------------*/
    DEC(){
        if(this.listaTokens[this.pos][0] == 'tkInt'
            || this.listaTokens[this.pos][0] == 'tkString'
            || this.listaTokens[this.pos][0] == 'tkDouble'
            || this.listaTokens[this.pos][0] == 'tkChar'
            || this.listaTokens[this.pos][0] == 'tkBoolean'
            || this.listaTokens[this.pos][0] == 'tkVoid'){
                this.TIPO();  
            }
            this.parea('tkIdentificador');
            if(this.listaTokens[this.pos][0] == 'tkIgual'){
                this.parea('tkIgual');
                this.EXP();
            }
    }

/*------------------------------------*
*                                     *
*_____________EXPRESIONES_____________*
*                                     *
*-------------------------------------*/
    EXP(){
        if(this.listaTokens[this.pos][0] == 'tkIdentificador'){
            this.parea('tkIdentificador');
            if(this.listaTokens[this.pos][0] == 'tkParAbierta'){
                this.parea('tkParAbierta');
                this.LISTAPARAMETROS();
                this.parea('tkParCerrada');
            }
            this.EXPP();           
        }else if(this.listaTokens[this.pos][0] == 'tkAdmiracion'){
            this.parea('tkAdmiracion')
            this.EXP();
            this.EXPP();
        }else if(this.listaTokens[this.pos][0] == 'tkMenos'){
            this.parea('tkMenos');
            this.EXP();
            this.EXPP();
        }else if(this.listaTokens[this.pos][0] == 'tkParAbierta'){
            this.parea('tkParAbierta');
            this.EXP();
            this.parea('tkParCerrada');
            this.EXPP();
        }else{
            this.VAL();
            this.EXPP();
        }

    }

    EXPP(){
        if(this.listaTokens[this.pos][0] == 'tkAnd'){
            this.parea('tkAnd');
            this.EXP()
        }
        if(this.listaTokens[this.pos][0] == 'tkOr'){
            this.parea('tkOr');
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkXor'){
            this.parea('tkXor');
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkMenor'){
            this.parea('tkMenor');
            if(this.listaTokens[this.pos][0] == 'tkIgual'){
                this.parea('tkIgual');
            }
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkMayor'){
            this.parea('tkMayor');
            if(this.listaTokens[this.pos][0] == 'tkIgual'){
                this.parea('tkIgual');
            }
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkIgual'){
            this.parea('tkIgual');            
            this.parea('tkIgual');            
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkMas'){
            this.parea('tkMas');
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkMenos'){
            this.parea('tkMenos');
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkDiv'){
            this.parea('tkDiv');
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkMulti'){
            this.parea('tkMulti');
            this.EXP();
        }
        if(this.listaTokens[this.pos][0] == 'tkAdmiracion'){
            this.parea('tkAdmiracion');
            this.parea('tkIgual');
            this.EXP();
        }

    }

    VAL(){
        switch (this.listaTokens[this.pos][0]) {
            case 'tkIdentificador':
                this.parea('tkIdentificador');
                break;
            case 'tkNumero':
                this.parea('tkNumero');
                break;
            case 'tkDecimal':
                this.parea('tkDecimal');
                break;
            case 'tkCadena':
                this.parea('tkCadena');
                break;
            case 'tkCadenaSimple':
                this.parea('tkCadenaSimple');
                break;
            case 'tkTrue':
                this.parea('tkTrue');
                break;
            case 'tkFalse':
                this.parea('tkFalse');
                break;
            default:
                break;
        }
    }
 
}

module.exports = parser;