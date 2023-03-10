<%! base = "" %><%namespace name="blocks" file="blocks.mako" inheritable="True"/>
<%!
from datetime import datetime
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${self.attr.title}Table Tennis Ladder 3.4.4</title>

    <!-- CSS -->
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <link href="${self.attr.base}static/css/ladder.css" rel="stylesheet">
    <link rel="stylesheet" href="${self.attr.base}static/js/ion.rangeSlider-2.1.2/css/ion.rangeSlider.css">
    <link rel="stylesheet" href="${self.attr.base}static/js/ion.rangeSlider-2.1.2/css/ion.rangeSlider.skinModern.css">

    % if datetime.now().month == 12:
      <link href="${self.attr.base}static/css/christmas.css" rel="stylesheet">
    % endif

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script type="text/javascript" src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script type="text/javascript" src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/jquery.tablesorter.min.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/jquery.flot.min.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/jquery.flot.time.min.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/jquery.floatThead.min.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/spin.min.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/ion.rangeSlider-2.1.2/js/ion-rangeSlider/ion.rangeSlider.min.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/moment.js"></script>
    <script type="text/javascript" src="${self.attr.base}static/js/ladder.js"></script>
  </head>
  <body>
    <nav class="navbar navbar-default">
      <div class="container-fluid">
        <p class="navbar-text tntfl-header">Table Tennis Ladder</p>
        <ul class="nav navbar-nav">
        <li><a href="${self.attr.base}.">Home</a></li>
        <li><a href="${self.attr.base}stats/">Stats</a></li>
        <li><a href="${self.attr.base}speculate/">Speculate</a></li>
        <li><a href="${self.attr.base}api/">API</a></li>
        <li><a href="${self.attr.base}historic/">Slice</a></li>
      </ul>

        <form class="navbar-form navbar-right game-entry" method="post" action="${self.attr.base}game/add/">
          <div class="form-group">
            <input type="text" name="redPlayer" class="form-control red player" placeholder="Red">
            <input type="text" name="redScore" class="form-control red score" placeholder="0" maxlength="2"> - <input type="text" name="blueScore" class="form-control blue score" placeholder="0" maxlength="2">
            <input type="text" name="bluePlayer" class="form-control blue player" placeholder="Blue">
            <script type="text/javascript">
            (function($){
              $(".game-entry input").change(function() {
                checkGameSubmitForm();
              })
            })( jQuery );
            </script>
          </div>
          <button type="submit" id="gameFormSubmit" disabled="true" class="btn btn-default" onClick="this.form.submit(); this.disabled=true;">Add game <span class="glyphicon glyphicon-triangle-right"></span></button>
        </form>
      </div><!-- /.container-fluid -->
    </nav>
    ${self.body()}
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
  </body>

</html>
