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
    --- 构造函数
    -- @param ModelFactory factory
    -- @string path
    -- @string uri
    new: ( factory, path, uri ) =>
        super factory, path, uri
        @name = @meta.aliases[1] if @meta.aliases
        if @meta.birthday
            date = for section in @meta.birthday\gmatch '%d+'
                section
            @meta.birthday = os.time year: date[1], month: date[2], day: date[3]

    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelActor.test'/mnt/video/g/2016/'
    test: ( path ) ->
        path ..= '/' if '/' != path\sub -1
        files = {
            'portrait.jpg',
            'metag.yml'
        }
        for file in *files
            return false if 'file' != lfs.attributes path .. file, 'mode'
        true

    --- 获取在指定时刻的年纪
    -- @function age
    -- @int[opt=nil] time
    -- @return int
    -- @usage age = actor:age
    age: ( time ) =>
        return if not @meta.birthday
        time = time or os.time()
        year = os.date '%Y', time
        year - os.date '%Y', @meta.birthday
