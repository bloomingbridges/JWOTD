
class Word
  constructor: (@date) ->
    console.log @date


$ ->
  word_of_the_day = new Word(new Date())

  # console.log "AppCache status: " + window.applicationCache.status

  if (localStorage.date)
    console.log "Existing: " + localStorage.meaning + " - " + localStorage.date + " - " + navigator.onLine
    word_of_the_day = localStorage
    setWordTo(word_of_the_day);

    # date = new Date
    # if (localStorage.date != date.getDate && navigator.onLine)

  console.log "Checking for new word.."

  $.getJSON "http://pipes.yahoo.com/pipes/pipe.run?_id=8b43c55269d587214112bc421c1e4711&_render=json&_callback=?",
    (data) ->
      console.log data
      # Get the first word
      for item in data.value.items
        word_of_the_day.kana = item.title
        word_of_the_day.date = item.pubDate
        word_of_the_day.kanji = (/kanji:\s<a.*>(.*)<\/a>/gi).exec(item.description)[1]
        word_of_the_day.romaji = (/romaji: (.*)</).exec(item.description)[1]
        word_of_the_day.meaning = (/definition: (.*)/gi).exec(item.description)[1]
        break

    setWordTo(word_of_the_day);
    console.log "INCOMING:", word_of_the_day
    $('#container').addClass('woosh')

  .error ->
    # no network. Use default word or fetch from local storage
    console.log "timeout?"
    $('#container').addClass('woosh')

  $('#kanji').click (event) ->
    $('#container, #kanji').addClass('selected')
    $('#pronunciation').css('height', '48px')
    $('#footer').addClass('woosh');

    $('#handle').click (event) ->
      $('#footer').toggleClass('reveal')

  $('a#'+localStorage.theme).parent('li').addClass('current')

  $('ul#themes li a').click (event) ->
    event.preventDefault()
    $('ul#themes li').removeClass 'current'
    $('link').attr 'href', event.target.href
    localStorage.theme = event.target.id
    $(event.target).parent('li').addClass('current')

setWordTo = (wotd) ->
  $('#kanji').html wotd.kanji
  $('#kana').html wotd.kana
  $('#romaji').html wotd.romaji
  $('#meaning').html wotd.meaning

  localStorage.date = wotd.date
  localStorage.kanji = wotd.kanji
  localStorage.kana = wotd.kana
  localStorage.romaji = wotd.romaji
  localStorage.meaning = wotd.meaning
