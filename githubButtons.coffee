$ = jQuery

addCommas = (n) ->
    n.toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')


$.fn.gitButtons = (options) ->
    defaults =
        method:     'follow',
        user:       'JasonMillward',
        repo:       'bootstrap',
        count:      true


    options = $.extend( defaults, options )
    @each ->
        button = $( this )

        count = 0
        forkers = 0
        watchers = 0
        followers = 0

        button.addClass( "github-btn github-watchers github-btn-large" )
        url = 'https://api.github.com/users/' + options.user
        home = 'https://github.com/' + options.user

        if options.method == 'follow'
            text = 'Follow @' + options.user

        else if options.method == 'watch' ||  options.method ==  'fork'
            if options.method ==  'fork'
                text = 'Fork'
            else
                text = 'Star'

            url = url + '/' + options.repo
            home = home + '/' + options.repo


        button.append(
            $('<a>').attr('href', home).attr( 'class', 'gh-btn').append(
                $('<span>').attr( 'class', 'gh-ico')
            ).append(
                $('<span>').attr( 'class', 'gh-text').text(text)
            )
        )


        if options.count
            $.ajax({
                type: 'GET',
                url: url,
                dataType: 'jsonp'
                success: (data) ->
                    if data.data['message'] != "Not Found"
                        if options.method == 'follow'
                            count = data.data['followers']
                        else if options.method == 'watch'
                            count = data.data['watchers']
                        else if options.method == 'fork'
                            count = data.data['forks']

                        button.append(
                            $('<a>').attr('href', home).attr('class', 'gh-count').text(addCommas(count))
                        )

                error: (x, t, m) ->
            })


