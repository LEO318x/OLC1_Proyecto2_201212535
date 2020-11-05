class scanner{
    constructor() {
        this.fila = 1;
        this.columna = 1;
        this.listaLexemas = [];
        this.listaTokens = [];
        this.listaErrorLexico = [];
    }

    analizar(_texto){
        let i = 0
        let ch = "";
        let lexema = "";
        let estado = 0;
        let datos = _texto+" ";
        while (i < datos.length){
            ch = datos[i];
            //console.log(ch.charCodeAt(0));

            
            switch (estado) {

                // Estado 0
                case 0:
                    if(ch == "\n"){
                        lexema += ch;
                        this.fila++;
                        this.columna = 1;
                        //this.listaLexemas.push([this.fila, this.columna, 'tkSaltoLinea', lexema]);
                        //this.listaTokens.push(['tkSaltoLinea', lexema]);
                        lexema = "";
                    }else if(ch.charCodeAt(0) == 32 || ch.charCodeAt(0) == 9){
                        this.columna++;
                        if(ch.charCodeAt(0) == 32){ // Espacio
                            //this.listaLexemas.push([this.fila, this.columna, 'tkEspacio', ch]);
                            //this.listaTokens.push(['tkEspacio', ch]);
                        }
                        if(ch.charCodeAt(0) == 9){ // Tabulacion
                            //this.listaLexemas.push([this.fila, this.columna, 'tkTab', ch]);
                            //this.listaTokens.push(['tkTab', ch]);
                        }
                    }else if(this.esNumero(ch)){
                        this.columna++;
                        lexema += ch;
                        estado = 1;
                    }else if(ch == '_' || this.esLetra(ch) || this.esNumero(ch)){
                        this.columna++;
                        lexema += ch;
                        estado = 5;
                    }else if(ch == '/'){
                        this.columna++;
                        if(datos[i+1] == '/' || datos[i+1] == '*'){
                            lexema += ch;
                            estado = 14;
                        }else{
                            lexema += ch;
                            estado = 4;
                        } 
                    }else if(this.esSimbolo(ch)){
                        lexema += ch;
                        estado = 4;
                    }else if(ch.charCodeAt(0) == 34){ // "
                        this.columna++;
                        lexema += ch;
                        estado = 6;
                    }else if(ch.charCodeAt(0) == 39){ // '
                        this.columna++;
                        lexema += ch;
                        estado = 10;
                    }else{
                        estado = 888;
                        i--;
                    }
                    break;

                // Estado 1
                case 1:
                    this.columna++;
                    if(this.esNumero(ch)){
                        estado = 1;
                        lexema += ch;
                    }else if(ch == '.'){
                        lexema += ch;
                        estado = 2;
                    }else{
                        //Agregamos el número y mandamos al estado 0
                        this.listaLexemas.push([this.fila, this.columna, 'tkNumero', lexema]);
                        this.listaTokens.push(['tkNumero', lexema]);
                        lexema = "";
                        estado = 0;
                        this.columna--;
                        i--;
                    }
                    break;

                // Estado 2
                case 2:
                    this.columna++;
                    if(this.esNumero(ch)){
                        lexema += ch;
                        estado = 3;
                    }else{
                        // Error                        
                        estado = 888;
                        this.columna++;
                        i--;
                    }
                    break;

                // Estado 3
                case 3:
                    this.columna++;
                    if(this.esNumero(ch)){
                        lexema += ch;
                        estado = 3;
                    }else{
                        //Agregamos el número decimal y mandamos al estado 0
                        this.listaLexemas.push([this.fila, this.columna, 'tkDecimal', lexema]);
                        this.listaTokens.push(['tkDecimal', lexema]);
                        lexema = "";
                        estado = 0;
                        this.columna--;
                        i--;
                    }
                    break;

                // Estado 4
                case 4:
                    this.agregarSimbolo(lexema);
                    lexema = "";
                    estado = 0;
                    this.columna--;
                    i--;
                    break;

                // Estado 5
                case 5:
                    this.columna++;
                    if(ch == '_' || this.esLetra(ch) || this.esNumero(ch)){
                        lexema += ch;
                        estado = 5;
                    }else{
                        //Agregamos el identificador y mandamos al estado 0
                        this.esReservada(lexema);
                        lexema = "";
                        estado = 0;
                        this.columna--;
                        i--;
                    }
                    break;
                
                // Estado 6
                case 6:
                    if(ch.charCodeAt(0) == 34){// "
                        this.columna++;
                        lexema += ch;
                        estado = 9;
                    }else if(ch.charCodeAt(0) == 92){ // \
                        
                        this.columna++;
                        lexema += ch;
                        estado = 7;
                    }else{
                        this.columna++;
                        lexema += ch;
                        estado = 6;
                    }
                    break;

                // Estado 7
                case 7:
                    if(ch.charCodeAt(0) == 34){ // "
                        this.columna++;
                        lexema += ch;
                        estado = 8;
                    }else{
                        this.columna++;
                        lexema += ch;
                        estado = 6;
                    }
                    break;

                // Estado 8
                case 8:
                    if(ch.charCodeAt(0) == 34){ // "
                        this.columna++;
                        lexema += ch;
                        estado = 9;
                    }else{
                        this.columna++;
                        lexema += ch;
                        estado = 6;
                    }
                    break;

                // Estado 9
                case 9:
                    this.listaLexemas.push([this.fila, this.columna, 'tkCadena', lexema]);
                    this.listaTokens.push(['tkCadena', lexema]);
                    lexema = "";
                    estado = 0;
                    this.columna--;
                    i--;
                    break;
                
                // Estado 10
                case 10:
                if(ch.charCodeAt(0) == 39){// '
                    this.columna++;
                    lexema += ch;
                    estado = 9;
                }else if(ch.charCodeAt(0) == 92){ // \
                    
                    this.columna++;
                    lexema += ch;
                    estado = 11;
                }else{
                    this.columna++;
                    lexema += ch;
                    estado = 10;
                }
                break;
            
                // Estado 11
                case 11:
                    if(ch.charCodeAt(0) == 39){ // '
                        this.columna++;
                        lexema += ch;
                        estado = 12;
                    }else{
                        this.columna++;
                        lexema += ch;
                        estado = 10;
                    }
                    break;
                
                // Estado 12
                case 12:
                    if(ch.charCodeAt(0) == 39){ // '
                        this.columna++;
                        lexema += ch;
                        estado = 13;
                    }else{
                        this.columna++;
                        lexema += ch;
                        estado = 10;
                    }
                    break;
                
                // Estado 13
                case 13:
                    this.listaLexemas.push([this.fila, this.columna, 'tkCadenaSimple', lexema]);
                    this.listaTokens.push(['tkCadenaSimple', lexema]);
                    lexema = "";
                    estado = 0;
                    this.columna--;
                    i--;
                    break;

                //Estado 14
                case 14:
                    if(ch == '/'){
                        this.columna++;
                        lexema += ch;
                        estado = 15;
                    }else if(ch == '*'){
                        this.columna++;
                        lexema += ch;
                        estado = 16;
                    }
                    break;

                // Estado 15
                case 15:
                    this.columna++;
                    if(ch == '\n'){
                        //this.listaLexemas.push([this.fila, this.columna, 'tkComentario', lexema]);
                        //this.listaTokens.push(['tkComentario', lexema]);
                        lexema = "";
                        estado = 0;
                        this.columna--;
                        i--;
                    }else{                    
                        lexema += ch;
                        estado = 15;
                    }
                    break;
                
                // Estado 16
                case 16:
                    this.columna++;
                    if(ch == '*'){                    
                        lexema += ch;
                        estado = 17;
                    }else{
                        lexema += ch;
                        estado = 16; 
                    }
                    break;
                
                // Estado 17
                case 17:
                    this.columna++;
                    if(ch == '*'){                    
                        lexema += ch;
                        estado = 17;
                    }else if(ch == '/'){                    
                        lexema += ch;
                        estado = 18;
                    }else{
                        lexema += ch;
                        estado = 16;  
                    }
                    break;

                // Estado 18
                case 18:
                    //this.listaLexemas.push([this.fila, this.columna, 'tkComentarioMulti', lexema]);
                    //this.listaTokens.push(['tkComentarioMulti', lexema]);
                    lexema = "";
                    estado = 0;
                    this.columna--;
                    i--;
                    break;

                // Estado Error
                case 888:
                    this.columna++;
                    lexema += ch;
                    this.listaErrorLexico.push([this.fila, this.columna, lexema, 'tkError']);
                    lexema = "";
                    estado = 0;
                    break;
                
                default:
                break;
            }
            i++;
        }
       // console.log(this.listaLexemas);
        //console.log("-------------------");
        //console.log(this.listaErrorLexico);
    }

    getListaTokens(){
        return this.listaTokens;
    }

    getListaLexemas(){
        return this.listaLexemas;
    }

    getListaErrorLexico(){
        return this.listaErrorLexico;
    }

    esNumero(ch){
        if (ch.charCodeAt(0) > 47 && ch.charCodeAt(0) < 58){
            return true;
        }else{
            return false;
        }
    }

    esLetra(ch){
        if (ch.charCodeAt(0) > 64 && ch.charCodeAt(0) < 91 || ch.charCodeAt(0) > 96 && ch.charCodeAt(0) < 123){
            return true;
        }else{
            return false;
        }
    }

    esReservada(lexema){
        switch (lexema) {

            case "public":
                this.listaLexemas.push([this.fila, this.columna, 'tkPublic', lexema]);
                this.listaTokens.push(['tkPublic', lexema]);
                break;

            case "class":
                this.listaLexemas.push([this.fila, this.columna, 'tkClass', lexema]);
                this.listaTokens.push(['tkClass', lexema]);
                break;

            case "interface":
                this.listaLexemas.push([this.fila, this.columna, 'tkInterface', lexema]);
                this.listaTokens.push(['tkInterface', lexema]);
                break;

            case "void":
                this.listaLexemas.push([this.fila, this.columna, 'tkVoid', lexema]);
                this.listaTokens.push(['tkVoid', lexema]);
                break;

            case "main":
                this.listaLexemas.push([this.fila, this.columna, 'tkMain', lexema]);
                this.listaTokens.push(['tkMain', lexema]);
                break;

            case "static":
                this.listaLexemas.push([this.fila, this.columna, 'tkStatic', lexema]);
                this.listaTokens.push(['tkStatic', lexema]);
                break;

            case "for":
                this.listaLexemas.push([this.fila, this.columna, 'tkFor', lexema]);
                this.listaTokens.push(['tkFor', lexema]);
                break;

            case "while":
                this.listaLexemas.push([this.fila, this.columna, 'tkWhile', lexema]);
                this.listaTokens.push(['tkWhile', lexema]);
                break;

            case "do":
                this.listaLexemas.push([this.fila, this.columna, 'tkDo', lexema]);
                this.listaTokens.push(['tkDo', lexema]);
                break;

            case "if":
                this.listaLexemas.push([this.fila, this.columna, 'tkIf', lexema]);
                this.listaTokens.push(['tkIf', lexema]);
                break;

            case "else":
                this.listaLexemas.push([this.fila, this.columna, 'tkElse', lexema]);
                this.listaTokens.push(['tkElse', lexema]);
                break;

            case "int":
                this.listaLexemas.push([this.fila, this.columna, 'tkInt', lexema]);
                this.listaTokens.push(['tkInt', lexema]);
                break;

            case "boolean":
                this.listaLexemas.push([this.fila, this.columna, 'tkBoolean', lexema]);
                this.listaTokens.push(['tkBoolean', lexema]);
                break;

            case "double":
                this.listaLexemas.push([this.fila, this.columna, 'tkDouble', lexema]);
                this.listaTokens.push(['tkDouble', lexema]);
                break;

            case "String":
                this.listaLexemas.push([this.fila, this.columna, 'tkString', lexema]);
                this.listaTokens.push(['tkString', lexema]);
                break;

            case "char":
                this.listaLexemas.push([this.fila, this.columna, 'tkChar', lexema]);
                this.listaTokens.push(['tkChar', lexema]);
                break;

            case "true":
                this.listaLexemas.push([this.fila, this.columna, 'tkTrue', lexema]);
                this.listaTokens.push(['tkTrue', lexema]);
                break;

            case "false":
                this.listaLexemas.push([this.fila, this.columna, 'tkFalse', lexema]);
                this.listaTokens.push(['tkFalse', lexema]);
                break;

            case "break":
                this.listaLexemas.push([this.fila, this.columna, 'tkBreak', lexema]);
                this.listaTokens.push(['tkBreak', lexema]);
                break;

            case "continue":
                this.listaLexemas.push([this.fila, this.columna, 'tkContinue', lexema]);
                this.listaTokens.push(['tkContinue', lexema]);
                break;

            case "return":
                this.listaLexemas.push([this.fila, this.columna, 'tkReturn', lexema]);
                this.listaTokens.push(['tkReturn', lexema]);
                break;

            case "System":
                this.listaLexemas.push([this.fila, this.columna, 'tkSystem', lexema]);
                this.listaTokens.push(['tkSystem', lexema]);
                break;

            case "out":
                this.listaLexemas.push([this.fila, this.columna, 'tkOut', lexema]);
                this.listaTokens.push(['tkOut', lexema]);
                break;

            case "print":
                this.listaLexemas.push([this.fila, this.columna, 'tkPrint', lexema]);
                this.listaTokens.push(['tkPrint', lexema]);
                break;

            case "println":
                this.listaLexemas.push([this.fila, this.columna, 'tkPrintln', lexema]);
                this.listaTokens.push(['tkPrintln', lexema]);
                break;
        
            default:
                this.listaLexemas.push([this.fila, this.columna, 'tkIdentificador', lexema]);
                this.listaTokens.push(['tkIdentificador', lexema]);
                break;
        }
    }

    esSimbolo(ch){
        if(ch == '(' || ch == ')' || ch == '{' || ch == '}' || ch == '[' || ch == ']' || ch == '&' || ch == '|' || ch == '^' || ch == '>' || ch == '<' || ch == '!' || ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '=' || ch == '.' || ch == ',' || ch == ':' || ch == ';' ){
            return true;
        }else{
            return false;
        }
    }

    agregarSimbolo(lexema){
        switch (lexema) {

            case "(":
                this.listaLexemas.push([this.fila, this.columna, 'tkParAbierta', lexema]);
                this.listaTokens.push(['tkParAbierta', lexema]);
                break;

            case ")":
                this.listaLexemas.push([this.fila, this.columna, 'tkParCerrada', lexema]);
                this.listaTokens.push(['tkParCerrada', lexema]);
                break;

            case "{":
                this.listaLexemas.push([this.fila, this.columna, 'tkLlaAbierta', lexema]);
                this.listaTokens.push(['tkLlaAbierta', lexema]);
                break;

            case "}":
                this.listaLexemas.push([this.fila, this.columna, 'tkLlaCerrada', lexema]);
                this.listaTokens.push(['tkLlaCerrada', lexema]);
                break;

            case "[":
                this.listaLexemas.push([this.fila, this.columna, 'tkCorAbierta', lexema]);
                this.listaTokens.push(['tkCorAbierta', lexema]);
                break;
                
            case "]":
                this.listaLexemas.push([this.fila, this.columna, 'tkCorCerrada', lexema]);
                this.listaTokens.push(['tkCorCerrada', lexema]);
                break;

            case "&":
                this.listaLexemas.push([this.fila, this.columna, 'tkAmperson', lexema]);
                this.listaTokens.push(['tkAmperson', lexema]);
                break;

            case "|":
                this.listaLexemas.push([this.fila, this.columna, 'tkBarVertical', lexema]);
                this.listaTokens.push(['tkBarVertical', lexema]);
                break;
            
            case "^":
                this.listaLexemas.push([this.fila, this.columna, 'tkXor', lexema]);
                this.listaTokens.push(['tkXor', lexema]);
                break;
                
            case ">":
                this.listaLexemas.push([this.fila, this.columna, 'tkMayor', lexema]);
                this.listaTokens.push(['tkMayor', lexema]);
                break;

            case "<":
                this.listaLexemas.push([this.fila, this.columna, 'tkMenor', lexema]);
                this.listaTokens.push(['tkMenor', lexema]);
                break;

            case "!":
                this.listaLexemas.push([this.fila, this.columna, 'tkAdmiracion', lexema]);
                this.listaTokens.push(['tkAdmiracion', lexema]);
                break;

            case "+":
                this.listaLexemas.push([this.fila, this.columna, 'tkMas', lexema]);
                this.listaTokens.push(['tkMas', lexema]);
                break;
                
            case "-":
                this.listaLexemas.push([this.fila, this.columna, 'tkMenos', lexema]);
                this.listaTokens.push(['tkMenos', lexema]);
                break;

            case "*":
                this.listaLexemas.push([this.fila, this.columna, 'tkMulti', lexema]);
                this.listaTokens.push(['tkMulti', lexema]);
                break;

            case "/":
                this.listaLexemas.push([this.fila, this.columna, 'tkDiv', lexema]);
                this.listaTokens.push(['tkDiv', lexema]);
                break;

            case "=":
                this.listaLexemas.push([this.fila, this.columna, 'tkIgual', lexema]);
                this.listaTokens.push(['tkIgual', lexema]);
                break;
                
            case ".":
                this.listaLexemas.push([this.fila, this.columna, 'tkPunto', lexema]);
                this.listaTokens.push(['tkPunto', lexema]);
                break;

            case ",":
                this.listaLexemas.push([this.fila, this.columna, 'tkComa', lexema]);
                this.listaTokens.push(['tkComa', lexema]);
                break;

            case ":":
                this.listaLexemas.push([this.fila, this.columna, 'tkDosPuntos', lexema]);
                this.listaTokens.push(['tkDosPuntos', lexema]);
                break;
            case ";":
                this.listaLexemas.push([this.fila, this.columna, 'tkPuntoComa', lexema]);
                this.listaTokens.push(['tkPuntoComa', lexema]);
                break;
        }
    }

}

module.exports = scanner;