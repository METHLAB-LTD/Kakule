Modernizr.load([
  {
    //load: '//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.js',
    load: '/javascripts/jquery-1.6.2.min.js',
    complete: function () {
      if ( !window.jQuery ) {
            Modernizr.load('/javascripts/jquery-1.6.2.min.js');
      }
    }
  }, 
  {
    load: '/javascripts/jquery.editinplace.js'
  }, 
  {
    load: '/javascripts/application.js'
  }, 
  { load: '/javascripts/event_calendar.js'
  }
]);
