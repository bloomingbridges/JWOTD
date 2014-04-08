
class Word
  constructor: (@date) ->
    
  parse: (item) ->
    @kana = item.title
    @date = item.pubDate
    @kanji = (/kanji:\s<a.*>(.*)<\/a>/gi).exec(item.description)[1]
    @romaji = (/romaji: (.*)</).exec(item.description)[1]
    @meaning = (/definition: (.*)</gi).exec(item.description)[1]

  store: ->
    localStorage.setItem 'lastUpdate', @date
    localStorage.setItem 'word', JSON.stringify(@)



$ ->

  # console.log "AppCache status: " + window.applicationCache.status
  word_of_the_day = new Word(new Date())

  if localStorage.getItem('lastUpdate') && localStorage.getItem('word')
    cachedWord = JSON.parse localStorage.getItem('word')
    console.log "EXISTING: " + cachedWord.meaning + " - " + cachedWord.date + " - " + navigator.onLine
    word_of_the_day = cachedWord
    setWordTo(word_of_the_day);
    word_of_the_day.store()

    # date = new Date
    # if (localStorage.date != date.getDate && navigator.onLine)

  bindUIHandlers()
  console.log "CHECKING FOR NEW WORD.."

  request = $.getJSON "http://pipes.yahoo.com/pipes/pipe.run?_id=8b43c55269d587214112bc421c1e4711&_render=json&_callback=?"
  request.success (data) ->
    console.log "INCOMING FEED:", data
    word_of_the_day.parse data.value.items[0]
    setWordTo(word_of_the_day);

  request.error ->
    console.log "### ERROR Fetching Feed"

  request.always ->
    $('#container').addClass('woosh')


bindUIHandlers = ->
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


