
class Word
  constructor: () ->
    @date = new Date()
    
  parse: (item) ->
    @kana = item.title
    @date = new Date item.pubDate
    @kanji = (/kanji:\s<a.*>(.*)<\/a>/gi).exec(item.description)[1]
    @romaji = (/romaji: (.*)</).exec(item.description)[1]
    @meaning = (/definition: (.*)</gi).exec(item.description)[1]

  store: ->
    localStorage.setItem 'lastUpdate', @date
    localStorage.setItem 'word', JSON.stringify
      kana: @kana
      date: @date
      kanji: @kanji
      romaji: @romaji
      meaning: @meaning


word = new Word()

$ ->

  # console.log "AppCache status: " + window.applicationCache.status

  if localStorage.getItem 'word'
    cached = JSON.parse localStorage.getItem('word')
    word.date = cached.date;
    word.kana = cached.kana;
    word.kanji = cached.kanji;
    word.romaji = cached.romaji;
    word.meaning = cached.meaning; 
    console.log "EXISTING: #{word.meaning} - #{word.date}"
    setWordTo word
    if !isUpToDate(new Date(word.date), new Date())
      fetchLatestWord()
  else
    fetchLatestWord()

  bindUIHandlers()
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
    localStorage.setItem 'theme', event.target.id
    $(event.target).parent('li').addClass('current')


isUpToDate = (lastPubDate, currentDate) ->
  # console.log lastPubDate.getDate(), currentDate.getDate()
  return lastPubDate.getDate() is currentDate.getDate()


fetchLatestWord = ->
  if (navigator.onLine)
    console.log "CHECKING FOR NEW WORD.."
    request = $.getJSON "http://pipes.yahoo.com/pipes/pipe.run?_id=8b43c55269d587214112bc421c1e4711&_render=json&_callback=?"
    request.success (data) ->
      # console.log "INCOMING FEED:", data
      console.log "INCOMING WORD:", data.value.items[0].title
      word.parse data.value.items[0]
      word.store()
      setWordTo word
    request.error ->
      console.log "### ERROR - COULD NOT ACCESS FEED"
  else
    console.log "### OFFLINE MODE"
  

setWordTo = (wotd) ->
  $('#kanji').html wotd.kanji
  $('#kana').html wotd.kana
  $('#romaji').html wotd.romaji
  $('#meaning').html wotd.meaning


