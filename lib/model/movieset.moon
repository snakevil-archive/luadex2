require 'lfs'
ModelNode = require 'model/node'
ModelMovie = require 'model/movie'

--- 影片索引节点模型组件
-- @module model/movieset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelMovieSet
class ModelMovieSet extends ModelNode
    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelMovieSet.test'/mnt/video/g/2016/'
    test: ( path ) ->
        path ..= '/' if '/' != path\sub -1
        for file in lfs.dir path
            dir = path .. file
            continue if '.' == file or '..' == file or 'directory' != lfs.attributes dir, 'mode'
            return true if ModelMovie.test dir
        false

    --- 获取子节点实例表
    -- @function children
    -- @return {ModelMovie,...}
    -- @usage movies = movieset:children()
    children: =>
        if not @_children
            @_children = {}
            @_assets = {}
            for name in lfs.dir @path
                path = @path .. name
                continue if '.' == name or '..' == name or 'directory' != lfs.attributes path, 'mode'
                child = @factory\load @uri .. name, ModelMovie
                table.insert @_children, child if child
        @_children
