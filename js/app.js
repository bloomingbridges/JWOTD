(function() {
  var $word_of_the_day, Word, bindUIHandlers, fetchLatestWord, isUpToDate, setWordTo;

  Word = (function() {
    function Word() {
      this.date = new Date();
    }

    Word.prototype.parse = function(item) {
      this.kana = item.title;
      this.date = new Date(item.pubDate);
      this.kanji = /kanji:\s<a.*>(.*)<\/a>/gi.exec(item.description)[1];
      this.romaji = /romaji: (.*)</.exec(item.description)[1];
      return this.meaning = /definition: (.*)</gi.exec(item.description)[1];
    };

    Word.prototype.store = function() {
      localStorage.setItem('lastUpdate', this.date);
      return localStorage.setItem('word', JSON.stringify(this));
    };

    return Word;

  })();

  $word_of_the_day = new Word();

  $(function() {
    if (localStorage.getItem('word')) {
      $word_of_the_day = JSON.parse(localStorage.getItem('word'));
      console.log("EXISTING: " + $word_of_the_day.meaning + " - " + $word_of_the_day.date);
      setWordTo($word_of_the_day);
      if (!isUpToDate(new Date($word_of_the_day.date), new Date())) {
        fetchLatestWord();
      }
    } else {
      fetchLatestWord();
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

  fetchLatestWord = function() {
    var request;
    if (navigator.onLine) {
      console.log("CHECKING FOR NEW WORD..");
      request = $.getJSON("http://pipes.yahoo.com/pipes/pipe.run?_id=8b43c55269d587214112bc421c1e4711&_render=json&_callback=?");
      request.success(function(data) {
        $word_of_the_day.parse(data.value.items[0]);
        $word_of_the_day.store();
        return setWordTo($word_of_the_day);
      });
      return request.error(function() {
        return console.log("### ERROR - COULD NOT ACCESS FEED");
      });
    } else {
      return console.log("### OFFLINE MODE");
    }
  };

  setWordTo = function(wotd) {
    $('#kanji').html(wotd.kanji);
    $('#kana').html(wotd.kana);
    $('#romaji').html(wotd.romaji);
    return $('#meaning').html(wotd.meaning);
  };

}).call(this);
