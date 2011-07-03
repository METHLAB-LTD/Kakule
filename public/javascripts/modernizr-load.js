Modernizr.load([
  {
    load: '//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.js',
    complete: function () {
      if ( !window.jQuery ) {
            Modernizr.load('javascripts/jquery-1.6.2.min.js');
      }
    }
  }, 
  {
    load: 'javascripts/application.js'
  }
]);
