/*jshint node:true*/
var fs = require('fs');

module.exports = function(app) {
  var express = require('express');
  var pageRouter = express.Router();

  pageRouter.get('/:id', function(req, res) {
    var path = __dirname + '/../../../build' + req.path + '/index.html';

    fs.readFile(path, {encoding: 'utf8'}, function(err, data) {
      if (err) {
       res.status(404).send('not found');
      }

      res.send({
        id: req.params.id,
        html: data
      });
    });

    // FIXME: would rather use a stream (as is done in the api viewer) but how do we handle this
    // with the need / desire to do this with JSON-API?

    /*
     var stream = fs.createReadStream(path);
     stream.on('error', function(e){
     res.status(404).send('not found');
     })

     res.set('Content-Type', 'text/json');
     stream.pipe(res);
     */

    //stream.on('error', function(e){
    //  res.status(404).send('not found');
    //});

  });

  app.use('/api/page', pageRouter);
};
