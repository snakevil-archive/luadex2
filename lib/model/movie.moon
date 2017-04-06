require 'lfs'
lyaml = require 'lyaml'
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
    --- 视频文件信息
    -- @field
    info: {}

    --- 获取视频文件信息
    -- @function get_info
    -- @string path
    -- @return table
    -- @usage info = get_info'/video'
    get_info = ( path ) ->
        path ..= '/' if '/' != path\sub -1
        cache = path .. 'minfo.yml'
        info = {
            video: {
                width: '720 pixels'
                height: '404 pixels'
                display_aspect_ratio: '16:9'
            }
        }
        if 'file' == lfs.attributes cache, 'mode'
            yaml = io.open cache
            info = lyaml.load yaml\read '*a'
            yaml\close!
        info

    --- 清理数值
    -- @function clear_num
    -- @string value
    -- @string[opt=nil] name desc
    -- @return number
    -- @usage value = clear_num('2 000 Kbps', 'Kbps')
    clear_num = ( value, suffix = nil ) ->
        value = value\gsub suffix .. '$', '' if suffix
        value = value\gsub '%s+', ''
        value - 0

    --- 构造函数
    -- @param ModelFactory factory
    -- @string path
    -- @string uri
    new: ( factory, path, uri ) =>
        super factory, path, uri
        @name = @meta.title or @name
        @meta.summary = @meta.summary\gsub '%s+', '' if @meta.summary
        date = [ section for section in @meta.date\gmatch '%d+' ]
        @meta.date = os.time year: date[1], month: date[2], day: date[3]
        @info = get_info path
        with @info.video
            .width = clear_num .width, 'pixels'
            .height = clear_num .height, 'pixels'
        if @info.general
            @info.general.overall_bit_rate = clear_num @info.general.overall_bit_rate, 'Kbps'
            @info.video.frame_rate = clear_num @info.video.frame_rate, 'fps'


    --- 检查路径是否符合节点特征
    -- @function test
    -- @string path
    -- @return bool
    -- @usage bingo = ModelMovie.test'/mnt/video/g/2016/'
    test: ( path ) ->
        path ..= '/' if '/' != path\sub -1
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
    assets: =>
        @children! if not @_assets
        @_assets = [ file for file in *@_assets when file\match '^snap%-%d+%.jpg$' ]
        @_assets
