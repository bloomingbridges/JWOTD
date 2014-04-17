(function() {
  var Word, bindUIHandlers, isUpToDate;

  Word = {
    parse: function(item, isCached) {
      var p, _i, _len, _ref, _results;
      this.kana = item.title;
      if (!isCached) {
        this.date = new Date(item.pubDate);
        this.kanji = /kanji:\s<a.*>(.*)<\/a>/gi.exec(item.description)[1];
        this.romaji = /romaji: (.*)</.exec(item.description)[1];
        return this.meaning = /definition: (.*)</gi.exec(item.description)[1];
      } else {
        _ref = ["date", "kanji", "romaji", "meaning"];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          p = _ref[_i];
          _results.push(this[p] = item[p]);
        }
        return _results;
      }
    },
    fetch: function() {
      var request;
      if (navigator.onLine) {
        console.log("CHECKING FOR NEW WORD..");
        request = $.getJSON("http://pipes.yahoo.com/pipes/pipe.run?_id=8b43c55269d587214112bc421c1e4711&_render=json&_callback=?");
        request.success((function(_this) {
          return function(data) {
            console.log("INCOMING WORD:", data.value.items[0].title);
            _this.parse(data.value.items[0], false);
            _this.store();
            return _this.display();
          };
        })(this));
        return request.error(function() {
          return console.log("### ERROR - COULD NOT ACCESS FEED");
        });
      } else {
        return console.log("### OFFLINE MODE");
      }
    },
    store: function() {
      localStorage.setItem('lastUpdate', this.date);
      return localStorage.setItem('word', JSON.stringify({
        kana: this.kana,
        date: this.date,
        kanji: this.kanji,
        romaji: this.romaji,
        meaning: this.meaning
      }));
    },
    display: function() {
      var p, _i, _len, _ref, _results;
      _ref = ["kanji", "kana", "romaji", "meaning"];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        _results.push($("#" + p).html(this[p]));
      }
      return _results;
    }
  };

  $(function() {
    var cached;
    Word.date = new Date;
    if (localStorage.getItem('word')) {
      cached = JSON.parse(localStorage.getItem('word'));
      Word.parse(cached, true);
      console.log("EXISTING: " + Word.meaning + " - " + Word.date);
      Word.display();
      if (!isUpToDate(new Date(Word.date), new Date())) {
        Word.fetch();
      }
    } else {
      Word.fetch();
    }
    bindUIHandlers();
    return $('#container').addClass('woosh');
  });

  bindUIHandlers = function() {
    $('#kanji').click(function(event) {
      $('#container, #kanji').addClass('selected');
      $('#pronunciation').css('height', '48px');
      return $('#footer').addClass('woosh');
    });
    $('#handle').click(function(event) {
      return $('#footer').toggleClass('reveal');
    });
    $('a#' + localStorage.theme).parent('li').addClass('current');
    return $('ul#themes li a').click(function(event) {
      event.preventDefault();
      $('ul#themes li').removeClass('current');
      $('link').attr('href', event.target.href);
      localStorage.setItem('theme', event.target.id);
      return $(event.target).parent('li').addClass('current');
    });
  };

  isUpToDate = function(lastPubDate, currentDate) {
    return lastPubDate.getDate() === currentDate.getDate();
  };

}).call(this);
