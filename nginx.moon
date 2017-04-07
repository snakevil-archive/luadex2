lap = os.clock!

with ngx
    if not .var.luadex
        .status = .HTTP_SERVICE_UNAVAILABLE
        .say '$luadex not set.'
        .exit .OK

    path = .var.luadex .. '/lib/?.lua;'
    package.path = path .. package.path if package.path\sub(1, #path) != path

    succeed, content = pcall require'luadex',
        path: .var.request_filename
        uri: .var.request_uri
        prefix: .var.luadex_prefix
        :lap

    if succeed
        .say content
    else
        .status = .HTTP_BAD_REQUEST
        .log .ERR, content
    .exit .OK
