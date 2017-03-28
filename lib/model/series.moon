ModelMovieSet = require 'model/movieset'

--- 系列节点模型组件
-- @module model/series
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelSeries
class ModelSeries extends ModelMovieSet
    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelSeries.test'/mnt/video/g/2016/'
    test: ( path ) ->
        '-' == path\gsub '^.*/%-/[^/]+/?$', '-'
