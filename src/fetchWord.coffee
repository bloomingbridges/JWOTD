
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
    localStorage.setItem 'word', JSON.stringify(@)


$word_of_the_day = new Word()

$ ->

  # console.log "AppCache status: " + window.applicationCache.status

  if localStorage.getItem 'word'
    $word_of_the_day = JSON.parse localStorage.getItem('word')
    console.log "EXISTING: " + $word_of_the_day.meaning + " - " + $word_of_the_day.date
    setWordTo $word_of_the_day
    if !isUpToDate(new Date($word_of_the_day.date), new Date())
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
      $word_of_the_day.parse data.value.items[0]
      $word_of_the_day.store()
      setWordTo $word_of_the_day
    request.error ->
      console.log "### ERROR - COULD NOT ACCESS FEED"
  else
    console.log "### OFFLINE MODE"
  


setWordTo = (wotd) ->
  $('#kanji').html wotd.kanji
  $('#kana').html wotd.kana
  $('#romaji').html wotd.romaji
  $('#meaning').html wotd.meaning


