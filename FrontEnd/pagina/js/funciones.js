function generarNombre(longitud) {
    var resultado           = '';
    var caracteres       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var tamanioCaracteres = caracteres.length;
    for ( var i = 0; i < longitud; i++ ) {
       resultado += caracteres.charAt(Math.floor(Math.random() * tamanioCaracteres));
    }
    return resultado;
 }

var guardarArchivo = (function () {
    var hoy = new Date();
    var fecha = hoy.getDate() + '-' + ( hoy.getMonth() + 1 ) + '-' + hoy.getFullYear();
    var hora = hoy.getHours() + '-' + hoy.getMinutes() + '-' + hoy.getSeconds();
    var fechaYHora = fecha + '_' + hora;
    var a = document.createElement("a");
    document.body.appendChild(a);
    a.style = "display: none";
    return function () {
        var blob = new File([javaEditor.getValue()], generarNombre(10)+'__'+fechaYHora+'.java');
            url = window.URL.createObjectURL(blob);
        a.href = url;
        a.download = blob.name;
        a.click();
        window.URL.revokeObjectURL(url);
    };
}());

function descargarArchivoTraduccionJS(datos, nombreArchivo, type) {
    var hoy = new Date();
    var fecha = hoy.getDate() + '-' + ( hoy.getMonth() + 1 ) + '-' + hoy.getFullYear();
    var hora = hoy.getHours() + '-' + hoy.getMinutes() + '-' + hoy.getSeconds();
    var fechaYHora = fecha + '_' + hora;
    var file = new Blob([datos], {type: type});
    if (window.navigator.msSaveOrOpenBlob)
        window.navigator.msSaveOrOpenBlob(file, nombreArchivo+'__'+fechaYHora+'.js');
    else { 
        var a = document.createElement("a"),
                url = URL.createObjectURL(file);
        a.href = url;
        a.download = nombreArchivo+'__'+fechaYHora+'.js';
        document.body.appendChild(a);
        a.click();
        setTimeout(function() {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);  
        }, 0); 
    }
}