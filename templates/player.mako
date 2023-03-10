<%!
title = ""
base = "../../"
from tntfl.game import Game
from tntfl.web import get_template
from tntfl.player import PerPlayerStat
from tntfl.pundit import Pundit
import tntfl.templateUtils as utils

def getPerPlayerStats(player):
    pps = {}
    for game in player.games:
        if game.redPlayer == player.name:
            if game.bluePlayer not in pps:
                pps[game.bluePlayer] = PerPlayerStat(game.bluePlayer)
            pps[game.bluePlayer].append(game.redScore, game.blueScore, -game.skillChangeToBlue)
        elif game.bluePlayer == player.name:
            if game.redPlayer not in pps:
                pps[game.redPlayer] = PerPlayerStat(game.redPlayer)
            pps[game.redPlayer].append(game.blueScore, game.redScore, game.skillChangeToBlue)
    return pps

def getSkillHistory(player):
    skill = 0
    skillHistory = []
    for game in player.games:
        if game.redPlayer == player.name:
            skill -= game.skillChangeToBlue
            skillHistory.append([game.time * 1000, skill])
        elif game.bluePlayer == player.name:
            skill += game.skillChangeToBlue
            skillHistory.append([game.time * 1000, skill])
    return skillHistory
%>
<%inherit file="html.mako" />
<%
pundit = Pundit()

streaks = player.getStreaks()
winStreak = streaks['win']
loseStreak = streaks['lose']
currentStreak = streaks['current']
currentStreakType = streaks['currentType']

overratedClass = "positive" if player.overrated() <= 0 else "negative"
elevenNilWins = utils.getNumYellowStripes(player, player.games)
pps = getPerPlayerStats(player)
rank = ladder.getPlayerRank(player.name)
redness = float(player.gamesAsRed) / len(player.games) if len(player.games) > 0 else 0
sideStyle = "background-color: rgb(" + str(int(round(redness * 255))) + ", 0, "  + str(int(round((1 - redness) * 255))) + ")"
goalRatio = (float(player.goalsFor) / player.goalsAgainst) if player.goalsAgainst > 0 else 0
goalRatioClass = "positive" if goalRatio > 1 else "negative" if goalRatio < 1 else ""
skillBounds = player.getSkillBounds()
skillChange = player.skillChangeToday()
skillChangeClass = "positive" if skillChange > 0 else "negative" if skillChange < 0 else ""
skillHistory = getSkillHistory(player)
rankChange = player.rankChangeToday()
rankChangeClass = "positive" if rankChange > 0 else "negative" if rankChange < 0 else ""
%>

<%def name="statBox(title, body, classes='', style='', offset=0, width=3, caption='')">
  <div class="col-sm-${width} col-md-offset-${offset * width}">
    <div class="panel panel-default panel-statbox" title="${caption}">
      <div class="panel-heading">
        <h3 class="statbox">${title}</h3>
      </div>
      <div class="panel-body ${classes}" style="${style}">
        ${body}
      </div>
    </div>
  </div>
</%def>

<%def name="achievementStat(ach, games)">
  <div class="col-sm-3">
    <div class="panel panel-default panel-statbox panel-achievement" title="${ach.description}">
      <div class="panel-heading">
        <h3 class="statbox">${ach.name}</h3>
      </div>
      <div class="panel-body achievement-${ach.__name__}">
        ${len(games)}
        <img src="${base}static/img/arrow-down.png"
          id="achievement-${ach.__name__}-arrow"
          onclick="togglecollapse('achievement-${ach.__name__}', '${base}')"
        />
        <ul class="list-unstyled achievement-games" id="achievement-${ach.__name__}-collapse">
          %for game in games:
            <li>
              ${self.blocks.render("gameLink", time=game.time, base=base)}
            </li>
          %endfor
        </ul>
      </div>
    </div>
  </div>
</%def>

<%def name="perPlayerStat(player, stat)">
    <%
    goalRatio = (float(stat.goalsFor)/stat.goalsAgainst) if stat.goalsAgainst > 0 else 0
    %>
  <tr>
    <td class="ladder-name"><a href="${base}player/${stat.opponent}">${stat.opponent}</a></td>
    <td><a href="${base}headtohead/${player.name}/${stat.opponent}/" title="Head to Head"><span class="glyphicon glyphicon-transfer"></span></a></td>
    <td class="ladder-stat">${stat.games}</td>
    <td class="ladder-stat">${stat.wins}</td>
    <td class="ladder-stat">${stat.losses}</td>
    <td class="ladder-stat">${stat.goalsFor}</td>
    <td class="ladder-stat">${stat.goalsAgainst}</td>
    <td class="ladder-stat">${"{:.3f}".format(goalRatio)}</td>
    <td class="ladder-stat ladder-skill">${"{:+.3f}".format(stat.skillChange)}</td>
  </tr>
</%def>

<div class="container-fluid">
  <div class="row">
    <div class="col-md-8">
      <div class="panel panel-default">
        <div class="panel-heading">
          <h1 class="panel-title">${player.name}</h1>
        </div>
        <div class="panel-body">
          <div class="row">
            ${statBox(title="Current Ranking", body=(rank if rank != -1 else "-"), classes=utils.getRankCSS(rank, len(ladder.getActivePlayers())))}
            ${statBox(title="Skill", body="{:.3f}".format(player.elo))}
            ${statBox(title="Overrated", body="{:.3f}".format(player.overrated()), classes=overratedClass)}
            ${statBox(title="Side preference", body="{:.2%}".format(redness if redness >= 0.5 else (1-redness)) + (" red" if redness >= 0.5 else " blue"), classes="side-preference", style=sideStyle)}
          </div>
          <div class="row">
            ${statBox(title="Total games", body=len(player.games))}
            ${statBox(title="Wins", body=player.wins)}
            ${statBox(title="Losses", body=player.losses)}
          </div>
          <div class="row">
            ${statBox(title="Points for", body=player.goalsFor)}
            ${statBox(title="Points against", body=player.goalsAgainst)}
            ${statBox(title="Point ratio", body=("{:.3f}".format(goalRatio)), classes=goalRatioClass)}
            ${statBox(title="11-0 wins", body=elevenNilWins)}
          </div>
          <div class="row">
            ${statBox(title="Games today", body=player.gamesToday)}
            ${statBox(title="Skill change today", body="{:.3f}".format(skillChange), classes=skillChangeClass)}
            ${statBox(title="Rank change today", body=rankChange, classes=rankChangeClass)}
            ${statBox(title="Current streak", body=get_template("durationStat.mako", value="{0} {1}".format(currentStreak.count, currentStreakType), fromDate=currentStreak.fromDate, toDate=currentStreak.toDate, base=self.attr.base))}
          </div>
          <div class="row">
            ${statBox(title="Highest ever skill", body=get_template("pointInTimeStat.mako", skill=skillBounds['highest']['skill'], time=skillBounds['highest']['time'], base=self.attr.base))}
            ${statBox(title="Lowest ever skill", body=get_template("pointInTimeStat.mako", skill=skillBounds['lowest']['skill'], time=skillBounds['lowest']['time'], base=self.attr.base))}
            ${statBox(title="Longest winning streak", body=get_template("durationStat.mako", value=winStreak.count, fromDate=winStreak.fromDate, toDate=winStreak.toDate, base=self.attr.base))}
            ${statBox(title="Longest losing streak", body=get_template("durationStat.mako", value=loseStreak.count, fromDate=loseStreak.fromDate, toDate=loseStreak.toDate, base=self.attr.base))}
          </div>
          <div class="row">
            ${statBox(title="Total achievements", body=str(sum([len(g) for g in player.achievements.values()])) + '<div class="date"><a href="#achievements">See all</a></div>' )}
          </div>
        </div>
      </div>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h2 class="panel-title">Skill Chart</h2>
        </div>
        <div class="panel-body">
          <div id="playerchart">&nbsp;</div>
          <script type="text/javascript">
            plotPlayerSkill("#playerchart", [ ${skillHistory} ]);
          </script>
        </div>
      </div>

      <div class="panel panel-default">
        <div class="panel-heading">
          <h2 class="panel-title">Per-Player Stats</h2>
        </div>
        <div class="panel-body">
          <table class="table table-striped table-hover ladder" id="pps">
            <thead>
              <tr>
                <th>Opponent</th>
                <th></th>
                <th>Games</th>
                <th>Wins</th>
                <th>Losses</th>
                <th>Points scored</th>
                <th>Points conceded</th>
                <th>Point Ratio</th>
                <th>Skill change</th>
              </tr>
            </thead>
            <tbody>
              % for stat in pps.values():
                ${perPlayerStat(player, stat)}
              % endfor
            </tbody>
          </table>
          <script type="text/javascript">
            $("#pps").tablesorter({sortList:[[9,1]], 'headers': { 1: { 'sorter': false}}});
          </script>
        </div>
      </div>

    </div>

    <div class="col-md-4">
      % if len(player.games) > 0:
        <div class="panel panel-default">
          <div class="panel-heading">
            <h2 class="panel-title">Recent Games</h2>
          </div>
          <div class="panel-body">
            ${self.blocks.render("recent", base=self.attr.base, games=player.games, limit=5)}
            <a class="pull-right" href="games/">See all games</a>
          </div>
        </div>
        <div class="panel panel-default">
          <div class="panel-heading">
            <h2 class="panel-title">Most Significant Game</h2>
          </div>
          <div class="panel-body">
            <div class="game table-responsive container-fluid">
              <table class="table no-table-boder" style="margin-top: 20px;">
                <tbody>
                  ${self.blocks.render("game", game=player.mostSignificantGame(), base=self.attr.base, punditryAvailable=utils.punditryAvailable(pundit, player.mostSignificantGame(), ladder), totalActivePlayers=len(ladder.getActivePlayers(player.mostSignificantGame().time-1)))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="panel panel-default">
          <div class="panel-heading">
            <h2 class="panel-title">First Ever Game</h2>
          </div>
          <div class="panel-body">
            <div class="game table-responsive container-fluid">
              <table class="table no-table-boder" style="margin-top: 20px;">
                <tbody>
                  ${self.blocks.render("game", game=player.games[0], base=self.attr.base, punditryAvailable=utils.punditryAvailable(pundit, player.games[0], ladder), totalActivePlayers=len(ladder.getActivePlayers(player.games[0].time-1)))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      % else:
        <p>This player has not played any games.</p>
      % endif
      <div class="panel panel-default">
        <a id="achievements"></a>
        <div class="panel-heading">
          <h2 class="panel-title">Achievements</h2>
        </div>
        <div class="panel-body">
          <div class="row">
            % for ach, games in player.achievements.iteritems():
              % if loop.index % 4 == 0:
                </div><div class="row">
              % endif
              ${achievementStat(ach, list(reversed(games)))}
            % endfor
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
