from flask import Flask
from tntfl.ladder import TableFootballLadder
from tntfl.web import get_template


app = Flask(__name__)


def getLadder():
    return TableFootballLadder("ladder.txt")


@app.route("/")
def index():
    return get_template("index.mako", ladder=getLadder())


@app.route("/stats/")
def stats():
    return get_template("stats.mako", ladder=getLadder())

if __name__ == "__main__":
    app.run()