const express = require('express');

const router = express.Router();

/* GET users listing. */
router.get('/', (req, res) => {
    const exampleData = ['user1', 'user2'];
    res.send(exampleData);
});

module.exports = router;
