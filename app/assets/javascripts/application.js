//= require 'ace/ace'
//= require 'ace/theme-twilight'
//= require 'ace/mode-ruby'

$(document).ready(function() {
  $('.nav li a').on('click', function(e) {
    e.preventDefault();
    $('.nav li a').each(function(index, dom) {
      if(e.target == dom) {
        $(dom).parent().addClass('active');
        $('#' + $(dom).parent().data('target')).removeClass('hidden');
      } else {
        $(dom).parent().removeClass('active');
        $('#' + $(dom).parent().data('target')).addClass('hidden');
      }
    });
  });

  var THEME = 'ace/theme/twilight';
  var MODE = 'ace/mode/ruby'

  var convertEditor = ace.edit('convert-editor')
  convertEditor.setTheme(THEME);
  convertEditor.getSession().setMode(MODE);

  var matchEditor = ace.edit('match-editor');
  matchEditor.setTheme(THEME);
  matchEditor.getSession().setMode(MODE);

  var rulesEditor = ace.edit('rules-editor');
  rulesEditor.setTheme(THEME);
  rulesEditor.getSession().setMode(MODE);

  convertEditor.getSession().on('change', sendConvertAjaxRequest); 
  matchEditor.getSession().on('change', sendMatchAjaxRequest);
  rulesEditor.getSession().on('change', sendMatchAjaxRequest);

  function sendConvertAjaxRequest(e) {
    var code = ace.edit('convert-editor').getSession().getValue();
    var request = $.ajax({
      dateType: 'json',
      type: 'POST',
      url: '/convert',
      data: { code: code }
    });

    request.done(function(msg) {
      var result = msg['result'];
      if(result) {
        result = result.replace(/\n/g, '<br />');
        result = result.replace(/ /g, '&nbsp');
        $('#convert-result').html(result);
      } else {
      }
    });

    request.fail(function(jqXHR, textStatus) {
    });
  }

  function sendMatchAjaxRequest(e) {
    var code = ace.edit('match-editor').getSession().getValue();
    var rules = ace.edit('rules-editor').getSession().getValue();
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
  }
});
