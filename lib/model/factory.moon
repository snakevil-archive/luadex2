require 'lfs'
ModelNode = require 'model/node'
ModelMovie = require 'model/movie'
ModelMovieSet = require 'model/movieset'
ModelActor = require 'model/actor'
ModelSeries = require 'model/series'
ModelActorSet = require 'model/actorset'
ModelSeriesSet = require 'model/seriesset'

--- 节点工厂组件
-- @module model/factory
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelFactory
class ModelFactory
    --- 根路径
    -- @field
    root = ''

    --- 根 URI
    -- @field
    prefix = ''

    --- 构造函数
    -- @string path
    -- @string uri
    new: ( path, uri ) =>
        paths = for section in path\gmatch '[^/]+'
            section
        uris = for section in uri\gmatch '[^/]+'
            section
        while paths[#paths] == uris[#uris]
            table.remove paths
            table.remove uris
        root = '/' .. table.concat(paths, '/') .. '/'
        prefix = '/' .. table.concat(uris, '/') .. '/'
        root = '/' if '//' == root
        prefix = '/' if '//' == prefix

    --- 节点实例表
    -- @field
    nodes = {}

    --- 节点类型表
    -- @field
    types = {
        ModelActorSet,
        ModelSeriesSet,
        ModelActor,
        ModelMovie,
        ModelSeries,
        ModelMovieSet,
        ModelNode
    }

    --- 识别 URI 生成节点实例
    -- @function load
    -- @string uri
    -- @param[opt] class prototype
    -- @return ModelNode
    -- @usage node = factory:load'/g/'
    -- @raise out of range.
    -- @raise oops for file
    load: ( uri, prototype ) =>
        uri ..= '/' if '/' != uri\sub -1
        return nodes[uri] if nodes[uri]
        error 'out of range.' if prefix != uri\sub 1, #prefix
        path = root .. uri\sub 1 + #prefix
        error 'oops for file.' if 'directory' != lfs.attributes path, 'mode'
        protoypes = if prototype
            { prototype }
        else
            types
        for type in *protoypes
            if type.test path
                nodes[uri] = type self, path, uri
                return nodes[uri]

    --- 获取根节点
    -- @function root
    -- @return ModelNode
    -- @usage root = factory:root()
    root: =>
        @load prefix

    --- 搜索最近的包含指定名称文件夹的上级 URI
    -- @function find_set
    -- @string uri
    -- @string[opt="@"] type
    -- @return string
    -- @usage uri = find_set('/g/2016/detective.conan.the.darkest.nightmare/', '-')
    find_set = ( uri, type = '@' ) ->
        paths = {
            root .. type
        }
        suffix = ''
        for section in uri\sub(1 + #prefix)\gmatch '[^/]+'
            suffix ..= section .. '/'
            table.insert paths, 1, root .. suffix .. type
        table.remove paths, 1
        for path in *paths
            return prefix .. path\sub(1 + #root) if 'directory' == lfs.attributes path, 'mode'

    --- 获取最近的演员索引节点组件实例
    -- @function actorset
    -- @param ModelNode node
    -- @return ModelActorSet
    -- @usage actorset = factory:actorset(node)
    actorset: ( node ) =>
        uri = find_set node.uri
        return @load uri if uri

    --- 获取最近的系列索引节点组件实例
    -- @function seriesset
    -- @param ModelNode node
    -- @return ModelSeriesSet
    -- @usage seriesset = factory:seriesset(node)
    seriesset: ( node ) =>
        uri = find_set node.uri, '-'
        return @load uri if uri
