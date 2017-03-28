require 'lfs'
lyaml = require 'lyaml'

--- 基础节点模型组件
-- @module model/node
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelNode
class ModelNode
    --- 使用工厂组件实例
    -- @field
    factory: nil

    --- 路径
    -- @field
    path: ''

    --- URI
    -- @field
    uri: ''

    --- 名称
    -- @field
    name: ''

    --- 元信息表
    -- @field
    meta: {}

    --- 构造函数
    -- @param ModelFactory factory
    -- @string path
    -- @string uri
    new: ( factory, path, uri ) =>
        path ..= '/' if '/' != path\sub -1
        uri ..= '/' if '/' != uri\sub -1
        @factory = factory
        @path = path
        @uri = uri
        @name = uri\gsub '^.*/([^/]+)/$', '%1'
        path ..= 'metag.yml'
        if 'file' == lfs.attributes path, 'mode'
            yaml = io.open path
            @meta = lyaml.load yaml\read '*a'
            yaml\close!

    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelNode.test'/mnt/video/g/2016/'
    test: ( path ) ->
        true

    --- 获取根节点实例
    -- @function root
    -- @return ModelNode
    -- @usage root = node:root()
    root: () =>
        @factory\root!

    --- 获取父节点实例
    -- @function parent
    -- @return ModelNode
    -- @usage parent = node:parent()
    parent: () =>
        root = @root!
        if root.uri != @uri
            uri = @uri\gsub '^(.*/)[^/]+/$', '%1'
            @factory\load uri

    --- 最近的演员索引节点实例
    _actorset: nil

    --- 获取最近的演员索引节点组件实例
    -- @function actorset
    -- @return ModelActorSet
    -- @usage actorset = node:actorset()
    actorset: () =>
        @_actorset = @factory\actorset(@) or '' if not @_actorset
        return @_actorset if '' != @_actorset

    --- 最近的系列索引节点组件实例
    _seriesset: nil

    --- 获取最近的系列索引节点组件实例
    -- @function seriesset
    -- @return ModelSeriesSet
    -- @usage seriesset = node:seriesset()
    seriesset: () =>
        @_seriesset = @factory\seriesset(@) or '' if not @_seriesset
        return @_seriesset if '' != @_seriesset

    --- 子节点实例表
    _children: nil

    --- 资源文件名表
    _assets: nil

    --- 获取子节点实例表
    -- @function children
    -- @return {ModelNode,...}
    -- @usage nodes = node:children()
    children: () =>
        if not @_children
            @_children = {}
            @_assets = {}
            for name in lfs.dir @path
                continue if '.' == name or '..' == name
                path = @path .. name
                switch lfs.attributes path, 'mode'
                    when 'file'
                        table.insert @_assets, name
                    when 'directory'
                        table.insert @_children, @factory\load @uri .. name
        @_children

    --- 获取资源文件名表
    -- @function assets
    -- @return {string,...}
    -- @usage files = node:assets()
    assets: () =>
        @children! if not @_assets
        @_assets
