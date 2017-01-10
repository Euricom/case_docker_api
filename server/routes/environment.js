const express = require('express');

const router = express.Router();

// environment
router.get('/', (req, res) => {
    const mongoUri = process.env.MONGODB_URI;
    if (mongoUri && mongoUri.length > 0) {
        res.send(mongoUri);
    } else {
        res.send('mongoUri environment variable niet gevonden');
    }
    res.send(mongoUri);
});

module.exports = router;
