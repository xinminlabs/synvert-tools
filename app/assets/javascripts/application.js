//= require 'ace/ace'
//= require 'ace/theme-twilight'
//= require 'ace/mode-ruby'
//= require 'jquery.slimscroll.min'

$(document).ready(function() {
  $('#convert-result').slimScroll({
    height: '600px',
    start: 'bottom'
  });

  $('#match-result').slimScroll({
    height: '467px',
    start: 'bottom'
  });

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

  var codeEditor = ace.edit('code-editor');
  codeEditor.setTheme(THEME);
  codeEditor.setOptions({
    fontSize: '18px',
    showGutter: false
  });
  codeEditor.getSession().setMode(MODE);
  codeEditor.getSession().setTabSize(TABSIZE);

  codeEditor.getSession().on('change', codeEditorValueChanged);
  codeEditorValueChanged();

  var snippetEditor = ace.edit('snippet-editor');
  snippetEditor.setTheme(THEME);
  snippetEditor.setOptions({
    fontSize: '16px',
    showGutter: false
  });
  snippetEditor.getSession().setMode(MODE);
  snippetEditor.getSession().setTabSize(TABSIZE);

  snippetEditor.getSession().on('change', snippetEditorValueChanged);

  $("input[name='rule']").on('change', sendMatchAjaxRequest);

  function codeEditorValueChanged() {
    sendPlayAjaxRequest();
    sendConvertAjaxRequest();
    sendMatchAjaxRequest();
  }

  function snippetEditorValueChanged() {
    sendPlayAjaxRequest();
  }

  function sendConvertAjaxRequest() {
    var code = ace.edit('code-editor').getSession().getValue();

    if (code.length == 0) {
      $('#convert-result').attr('class', 'alert alert-info')
                          .html('Try to input your ruby code at the left side');
      return;
    }

    var request = $.ajax({
      dateType: 'json',
      type: 'POST',
      url: '/convert',
      data: { code: code }
    });

    request.done(function(msg) {
      var result = msg.result;
      if (result) {
        $('#convert-result').attr('class', 'alert alert-success')
                            .html(result)
                            .slimScroll({ scrollTo: '99999px' })
        $('#match-result').slimScroll({ scrollTo: '99999px' })
      } else {
        $('#convert-result').attr('class', 'alert alert-warning')
                            .html('No result is returned. Please try it again.');
      }
    });

    request.fail(function(jqXHR, textStatus) {
      $('#convert-result').attr('class', 'alert alert-danger')
                          .html('Error occurred. Please try it again');
    });
  }

  function sendMatchAjaxRequest() {
    var code = ace.edit('code-editor').getSession().getValue();
    var rule = $("input[name='rule']").val();

    if (code.length == 0 || rule.length == 0) {
      $('#match-result').attr('class', 'alert alert-info')
                        .html('Try to input your ruby code at the left side');
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
      var matchings = msg.matchings;
      if(matchings[0] == 'match') {
        $('#match-result').attr('class', 'alert alert-success')
                          .append(matchings[1])
                          .slimScroll({ scrollTo: '99999px' });
        $('#convert-result').slimScroll({ scrollTo: '99999px' })
      }
    });

    request.fail(function(jqXHR, textStatus) {
      $('#match-result').attr('class', 'alert alert-danger')
                        .html('Error occurred. Please try it again');
    });
  }

  function sendPlayAjaxRequest() {
    var code = ace.edit('code-editor').getSession().getValue();
    var snippet = ace.edit('snippet-editor').getSession().getValue();

    if (code.length == 0 || snippet.length == 0) {
      $('#play-result').attr('class', 'alert alert-info')
                          .html('Try to input your ruby code at left side');
      return;
    }

    var request = $.ajax({
      dataType: 'json',
      type: 'POST',
      url: '/play',
      data: { code: code, snippet: snippet }
    });

    request.done(function(msg) {
      $('#play-result').attr('class', 'alert alert-success')
                       .html(msg.result)
                       .slimScroll({ scrollTo: '99999px' });
    });

    request.fail(function(jqXHR, textStatus) {
      $('#convert-result').attr('class', 'alert alert-danger')
                          .html('Error occurred. Please try it again');
    });
  }
});
