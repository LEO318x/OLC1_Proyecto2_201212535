const express = require('express');
const app = express();
const morgan = require('morgan');
var cors = require('cors');

//Configuraciones
app.set('port', 3030);
app.use(morgan('dev'));
app.use(express.urlencoded({extended: false}));
app.use(express.json());
app.use(cors());
app.use(require('./rutas/index'));

app.listen(app.get('port'), () => {
    console.log("Corriendo en puerto 3030");
});