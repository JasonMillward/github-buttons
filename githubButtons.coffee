$ = jQuery

debug = true



addCommas = (n) ->
    n.toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')

ucaseFirst = (str) ->
    str.charAt(0).toUpperCase() + str.slice(1);

log = (str) ->
    if debug
        currentTime = new Date

        h = currentTime.getHours()
        m = currentTime.getMinutes()
        s = currentTime.getSeconds()

        try
            console.log("[" + h + ":" + m + ":" + s + "]\t" + str)

        catch e

$.fn.gitButtons = ->
    @each ->
        button = $( this )

        options =
            user:   button.attr('data-user')
            method: button.attr('data-type')
            repo:   button.attr('data-repo')
            count:  button.attr('data-count')

        button.addClass( "github-btn github-watchers github-btn-large" )

        link = 'https://github.com/' + options.user

        if options.method == 'follow'
            text = 'Follow @' + options.user
            url  = 'https://api.github.com/users/' + options.user

        else if options.method == 'star' ||  options.method ==  'fork'
            text = ucaseFirst(options.method)
            url  = 'https://api.github.com/repos/' + options.user + '/' + options.repo
            link = link + '/' + options.repo


        button.append(
            $('<a>').attr('href', link).attr( 'class', 'gh-btn').append(
                $('<span>').attr( 'class', 'gh-ico')
            ).append(
                $('<span>').attr( 'class', 'gh-text').text(text)
            )
        )

        if options.count == "true"
            $.ajax
                type: 'GET',
                url: url,
                dataType: 'jsonp'
                success: (data) ->

                    if typeof data.data['message'] == "undefined"

                        if options.method == 'follow'
                            count = data.data['followers']

                        if options.method == 'star'
                            count = data.data['watchers']

                        if options.method == 'fork'
                            count = data.data['forks']

                        button.append(
                            $('<a>').attr('href', link).attr('class', 'gh-count').text(addCommas(count))
                        )

                    else
                        log data.data['message']

                error: (x, t, m) ->



