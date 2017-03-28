require 'lfs'
ModelNode = require 'model/node'

--- 影片节点模型组件
-- 此节点应包含以下文件：
-- * cover.jpg - 封皮图片
-- * movie.mp4 - 影片视频
-- * metag.yml - 元信息文件
-- @module model/movie
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ModelMovie
class ModelMovie extends ModelNode
    --- 发行时间
    -- @field
    _time: 0

    --- 构造函数
    -- @param ModelFactory factory
    -- @string path
    -- @string uri
    new: ( factory, path, uri ) =>
        super factory, path, uri
        @name = @meta.title or @name
        @meta.summary = @meta.summary\gsub '%s+', '' if @meta.summary
        date = for section in @meta.date\gmatch '%d+'
            section
        @_time = os.time year: date[1], month: date[2], day: date[3]

    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelMovie.test'/mnt/video/g/2016/'
    test: ( path ) ->
        path ..= '/' if '/' != path[-1]
        files = {
            'cover.jpg',
            'movie.mp4',
            'metag.yml'
        }
        for file in *files
            return false if 'file' != lfs.attributes path .. file, 'mode'
        true

    --- 获取资源文件名表
    -- @function assets
    -- @return {string,...}
    -- @usage files = movie:assets()
    assets: () =>
        @children! if not @_assets
        @_assets = for file in *@_assets
            file if file\match '^snap%-%d+%.jpg$'
        @_assets

    --- 格式化发行时间
    -- @function date
    -- @string[opt="%c"] format
    -- @return string
    -- @usage year = movie:date'%Y'
    date: ( format = '%c' ) =>
        os.date format, @_time
