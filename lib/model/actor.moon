require 'lfs'
ModelMovieSet = require 'model/movieset'

--- 演员节点模型组件
-- 此节点应包含以下文件：
-- * portrait.jpg - 头像图片
-- * metag.yml - 元信息文件
-- @module model/actor
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelActor
class ModelActor extends ModelMovieSet
    --- 生日时间
    -- @field
    _time: 0

    --- 构造函数
    -- @param ModelFactory factory
    -- @string path
    -- @string uri
    new: ( factory, path, uri ) =>
        super factory, path, uri
        @name = @meta.aliases[1] if @meta.aliases
        date = for section in @meta.birthday\gmatch '%d+'
            section
        @_time = os.time year: date[1], month: date[2], day: date[3]

    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelActor.test'/mnt/video/g/2016/'
    test: ( path ) ->
        path ..= '/' if '/' != path[-1]
        files = {
            'portrait.jpg',
            'metag.yml'
        }
        for file in *files
            return false if 'file' != lfs.attributes path .. file, 'mode'
        true

    --- 格式化生日时间
    -- @function date
    -- @string[opt="%c"] format
    -- @return string
    -- @usage year = movie:date'%Y'
    date: ( format = '%c' ) =>
        os.date format, @_time
