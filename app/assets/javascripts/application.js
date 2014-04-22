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
  var TABSIZE = 2;

  var convertEditor = ace.edit('convert-editor')
  convertEditor.setTheme(THEME);
  convertEditor.getSession().setMode(MODE);
  convertEditor.getSession().setTabSize(TABSIZE);

  var matchEditor = ace.edit('match-editor');
  matchEditor.setTheme(THEME);
  matchEditor.getSession().setMode(MODE);
  matchEditor.getSession().setTabSize(TABSIZE);

  convertEditor.getSession().on('change', sendConvertAjaxRequest); 
  matchEditor.getSession().on('change', sendMatchAjaxRequest);

  convertEditor.getSession().trigger('change');
  matchEditor.getSession().trigger('change');

  function sendConvertAjaxRequest(e) {
    var code = ace.edit('convert-editor').getSession().getValue();

    if(code.length == 0) {
      $('#convert-result').attr('class', 'alert alert-alert');
      $('#convert-result').html('Try to input your ruby code at the left side');
      return;
    }

    var request = $.ajax({
      dateType: 'json',
      type: 'POST',
      url: '/convert',
      data: { code: code }
    });

    request.done(function(msg) {
      var result = msg['result'];
      if(result) {
        $('#convert-result').attr('class', 'alert alert-success');
        $('#convert-result').html(result);
      } else {
        $('#convert-result').attr('class', 'alert alert-warning');
        $('#convert-result').html('No result is returned. Please try it again.');
      }
    });

    request.fail(function(jqXHR, textStatus) {
      $('#convert-result').attr('class', 'alert alert-danger');
      $('#convert-result').html('Error occurred. Please try it again');
    });
  }

  function sendMatchAjaxRequest(e) {
    var code = ace.edit('match-editor').getSession().getValue();
    var rule = $("input[name='rule']").val();

    if(code.length == 0 || rule.length == 0) {
      $('#match-result').attr('class', 'alert alert-info');
      $('#match-result').html('Try to input your ruby code at the left side');
      return;
    }

    var request = $.ajax({
      dataType: 'json',
      type: 'POST',
      url: '/match',
      data: { code: code, rule: rule }
    });
    request.done(function(msg) {
      $('#match-result').html('');
      var matchings = msg['matchings'];
      if(matchings[0] == 'match') {
        $('#match-result').attr('class', 'alert alert-success');
        $('#match-result').append(msg['matchings'][1]);
      }
    });

    request.fail(function(jqXHR, textStatus) {
      $('#match-result').attr('class', 'alert alert-danger');
      $('#match-result').html('Error occurred. Please try it again');
    });
  }
});
