require 'lfs'
ModelNode = require 'model/node'
ModelSeries = require 'model/series'

--- 系列索引节点模型组件
-- @module model/seriesset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelSeriesSet
class ModelSeriesSet extends ModelNode
    --- 构造函数
    -- @param ModelFactory factory
    -- @string path
    -- @string uri
    new: ( factory, path, uri ) =>
        super factory, path, uri
        @name = 'Series'

    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelSeriesSet.test'/mnt/video/g/2016/'
    test: ( path ) ->
        '-' == path\gsub '^.*/([^/]+)/$', '%1'

    --- 获取子节点实例表
    -- @function children
    -- @return {ModelActor,...}
    -- @usage actors = seriesset:children()
    children: () =>
        if not @_children
            @_children = {}
            @_assets = {}
            for name in lfs.dir @path
                path = @path .. name
                continue if '.' == name or '..' == name or 'directory' != lfs.attributes path, 'mode'
                table.insert @_children, @factory\load @uri .. name
        @_children
