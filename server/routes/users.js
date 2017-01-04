var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
   const exampleData = ['user1', 'user2'];
   res.send(exampleData)
})

module.exports = router;
