const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const conexion = require('../conexion/index');
const router = express.Router();

// Endpoint para el registro de usuarios
router.post('/register', async (req, res) => {
    try {
        const {
            nombre,
            apellido,
            correo,
            contrasena,
            telefono,
            descripcion,
            documento,
            tipo_documento
        } = req.body;

        // Verificar si el correo ya está en uso
        const correoExistenteQuery = `SELECT * FROM usuario WHERE correo = "${correo}"`;
        conexion.query(correoExistenteQuery, async (error, results) => {
            if (results.length > 0) {
                res.status(400).json({ error: 'El correo ya está en uso' });
            } else {
                // Encriptar la contrasena con bcrypt
                const hashedPassword = await bcrypt.hash(contrasena, 10); // 10 es el número de rondas de hashing

                // Insertar el nuevo usuario en la base de datos
                const insertUserQuery = `INSERT INTO usuario (id_rol, nombre, apellido, correo, contrasena, telefono, descripcion, documento, tipo_documento) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;
                conexion.query(insertUserQuery, [3, nombre, apellido, correo, hashedPassword, telefono, descripcion, documento, tipo_documento], (error, result) => {
                    if (error) {
                        console.log(error);
                        res.status(500).json({ error: 'Error al registrar el usuario' });
                    } else {
                        
                        res.status(201).json({ message: 'Usuario registrado exitosamente'});
                    }
                });
            }
        });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: 'Error en el servidor' });
    }
});

module.exports = router;
