const scanner = require('./lexico');
const parser = require('./parser');

class analizador{
    analizar(datosEntrada){
        var lexico = new scanner();
        lexico.analizar(datosEntrada);
        //lexico.getListaTokens();
        
        var sintactico = new parser(lexico.getListaTokens());
        sintactico.inicio();
        //console.log(sintactico.getTraduccion());
        
        return [{listaTokens: lexico.getListaLexemas()}, {listaErroresLexicos: lexico.getListaErrorLexico()}, {listaErroresSintacticos: []}, {listaTraduccion: sintactico.getTraduccion()}];
    }
}

module.exports = analizador;


