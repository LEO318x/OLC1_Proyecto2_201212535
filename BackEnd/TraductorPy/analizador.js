const scanner = require('./lexico');
const parser = require('./parser');

var lexico = new scanner();
lexico.analizar("public interface interfaz{public int resta(int x, int y);public int resta(int a, int b);public void ejecutar();}public class clase{public static void main(String[] args) {int a, b;a = 10;b = 10;System.out.println(\"Hola mundo!\");}public int suma(int a, int b){resultado = a + b;return resultado;}}");
//lexico.getListaTokens();

var sintactico = new parser(lexico.getListaTokens());
sintactico.inicio();

//var t = new parser(test.getListaLexemas());

