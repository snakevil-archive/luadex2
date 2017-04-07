ModelFactory = require 'model/factory'
ViewFactory = require 'view/factory'

--- （弱）控制器组件
-- 本程序因只处理对不同类型节点（目录）的处理，路由、派发、控制都是单线流向，因此弱化合并一起处理。
-- @module luadex
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @function luadex
-- @param {path=string, uri=string} request
-- @return string
luadex = ( request ) ->
    { :path, :uri, :prefix, :lap } = request

    path ..= '/' if '/' != path\sub(-1)
    uri = uri\gsub '%%(%x%x)', (hex) ->
        string.char tonumber hex, 16
    uri ..= '/' if '/' != uri\sub(-1)

    node_factory = ModelFactory(path, uri)\reset!
    page = ViewFactory!\analyse node_factory\load uri
    html = page\render
        :prefix
    html = html\gsub('>%s+', '>')\gsub '%s+<', '<'
    html\gsub '%%PROFILER%%',
        '<mark>%d</mark> nodes in <mark>%.2f</mark> ms'\format node_factory\stats!,
            1000 * (os.clock! - lap)

luadex
