//= require 'ace/ace'
//= require 'ace/theme-twilight'
//= require 'ace/mode-ruby'

$(document).ready(function() {
  $('#convert-container textarea').on('change keyup paste', function() {
    var code = $('#convert-container textarea').val();

    var request = $.ajax({
      dateType: 'json',
      type: 'POST',
      url: '/convert',
      data: { code: code }
    });

    request.done(function(msg) {
      var result = msg['result'];
      if(result) {
        console.log(result);
        result = result.replace(/\n/g, '<br />');
        result = result.replace(/ /g, '&nbsp');
        $('#convert-result').html(result);
      } else {
      }
    });

    request.fail(function(jqXHR, textStatus) {
    });
  });

  $('#match-container textarea').on('change keyup paste', function() {
    var code = $("#match-container textarea[name='code']").val();
    var rules = $("#match-container textarea[name='rules']").val();
    var request = $.ajax({
      dataType: 'json',
      type: 'POST',
      url: '/match',
      data: { code: code, rules: rules }
    });
    request.done(function(msg) {
      $('#match-result').html('');
      var matchings = msg['matchings'];
      if(matchings[0] == 'match') {
        $('#match-result').append(msg['matchings'][1]);
      }
    });

    request.fail(function(jqXHR, textStatus) {
      $('#match-result').html('error');
    });
  });
});
