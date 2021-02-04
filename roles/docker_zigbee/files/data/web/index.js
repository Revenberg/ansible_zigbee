var express = require('express');
var app = express();         
app.get('/about', function (req, res) {
        console.log('on about');
});