const { Router } = require('express');
const router = Router();
const analizador = require('../analizador');

router.get('/', (req, res) =>{
    res.json({"Title": "Test"});
});

router.post('/traducirpy', (req, res) =>{
    textoAnalizar = req.body.data;    
    //console.log("-->"+req.body.data);

    try {
                      
        analisis = new analizador();
        analisis = analisis.analizar(textoAnalizar);
        //analizador.LimpiarListas();
        res.send(analisis);       
      } catch (error) {
        console.error(error);
      }
});


module.exports = router;
