require 'lfs'
ModelNode = require 'model/node'
ModelActor = require 'model/actor'

--- 影片索引节点模型组件
-- @module model/actorset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelActorSet
class ModelActorSet extends ModelNode
    --- 构造函数
    -- @param ModelFactory factory
    -- @string path
    -- @string uri
    new: ( factory, path, uri ) =>
        super factory, path, uri
        @name = 'Actors'

    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelActorSet.test'/mnt/video/g/2016/'
    test: ( path ) ->
        '@' == path\gsub '^.*/([^/]+)/?$', '%1'

    --- 获取子节点实例表
    -- @function children
    -- @return {ModelActor,...}
    -- @usage actors = actorset:children()
    children: () =>
        if not @_children
            @_children = {}
            @_assets = {}
            for name in lfs.dir @path
                path = @path .. name
                continue if '.' == name or '..' == name or 'directory' != lfs.attributes path, 'mode'
                child = @factory\load @uri .. name, ModelActor
                table.insert @_children, child if child
        @_children

    --- 获取指定名称的演员子节点
    -- @function child
    -- @string name
    -- @return ModelActor
    -- @usage actor = actorset:child'Cloy'
    child: ( name ) =>
        for actor in *@children!
            return actor if actor.name == name
