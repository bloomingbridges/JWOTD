(function() {
  var Word, setWordTo;

  Word = (function() {
    function Word(date) {
      this.date = date;
      console.log(this.date);
    }

    return Word;

  })();

  $(function() {
    var word_of_the_day;
    word_of_the_day = new Word(new Date());
    if (localStorage.date) {
      console.log("Existing: " + localStorage.meaning + " - " + localStorage.date + " - " + navigator.onLine);
      word_of_the_day = localStorage;
      setWordTo(word_of_the_day);
    }
    console.log("Checking for new word..");
    $.getJSON("http://pipes.yahoo.com/pipes/pipe.run?_id=8b43c55269d587214112bc421c1e4711&_render=json&_callback=?", function(data) {
      var item, _i, _len, _ref, _results;
      console.log(data);
      _ref = data.value.items;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        word_of_the_day.kana = item.title;
        word_of_the_day.date = item.pubDate;
        word_of_the_day.kanji = /kanji:\s<a.*>(.*)<\/a>/gi.exec(item.description)[1];
        word_of_the_day.romaji = /romaji: (.*)</.exec(item.description)[1];
        word_of_the_day.meaning = /definition: (.*)/gi.exec(item.description)[1];
        break;
      }
      return _results;
    }, setWordTo(word_of_the_day), console.log("INCOMING:", word_of_the_day), $('#container').addClass('woosh')).error(function() {
      console.log("timeout?");
      return $('#container').addClass('woosh');
    });
    $('#kanji').click(function(event) {
      $('#container, #kanji').addClass('selected');
      $('#pronunciation').css('height', '48px');
      $('#footer').addClass('woosh');
      return $('#handle').click(function(event) {
        return $('#footer').toggleClass('reveal');
      });
    });
    $('a#' + localStorage.theme).parent('li').addClass('current');
    return $('ul#themes li a').click(function(event) {
      event.preventDefault();
      $('ul#themes li').removeClass('current');
      $('link').attr('href', event.target.href);
      localStorage.theme = event.target.id;
      return $(event.target).parent('li').addClass('current');
    });
  });

  setWordTo = function(wotd) {
    $('#kanji').html(wotd.kanji);
    $('#kana').html(wotd.kana);
    $('#romaji').html(wotd.romaji);
    $('#meaning').html(wotd.meaning);
    localStorage.date = wotd.date;
    localStorage.kanji = wotd.kanji;
    localStorage.kana = wotd.kana;
    localStorage.romaji = wotd.romaji;
    return localStorage.meaning = wotd.meaning;
  };

}).call(this);
