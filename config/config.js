const mysql = require('mysql2');

const db = mysql.createConnection({   
    host: 'mx122.hostgator.mx', // Cambiar por el host correcto
    user: 'rgvconsu_sehas', // Tu usuario de base de datos
    password: 'soluciones_empresariales', // Tu contraseña de base de datos
    database: 'rgvconsu_delivery', // El nombre de tu base de datos
    port: 3306 // Puerto MySQL (por defecto) 
});

db.connect(function(err) {
    if (err) throw err;
    console.log('DATABASE CONNECTED!');
});

module.exports = db;