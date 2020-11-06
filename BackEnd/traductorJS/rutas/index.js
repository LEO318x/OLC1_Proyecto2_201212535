const { Router } = require('express');
const router = Router();
const analizador = require('../analizador');
const analizadorArbol = require('../analizadorarb');

router.get('/', (req, res) =>{
    res.json({"Title": "Test"});
});

router.post('/traducirjs', (req, res) =>{
    textoAnalizar = req.body.data;    
    //console.log("-->"+req.body.data);

    try {
                      
        analisis = new analizador.parse(textoAnalizar);
        analizador.LimpiarListas();
        
        analisisArbol = new analizadorArbol.parse(textoAnalizar);
        //console.log(analisisArbol);
        res.send(analisis.concat(analisisArbol));       
      } catch (error) {
        console.error(error);
      }
});


module.exports = router;
