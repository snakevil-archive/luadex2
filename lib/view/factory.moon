ViewNode = require 'view/node'
ViewMovie = require 'view/movie'
ViewMovieSet = require 'view/movieset'
ViewActor = require 'view/actor'
ViewSeries = require 'view/series'
ViewActorSet = require 'view/actorset'
ViewSeriesSet = require 'view/seriesset'

--- 视图工厂组件
-- @module view/factory
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ViewFactory
class ViewFactory
    --- 根据节点实例生成视图实例
    -- @param ModelNode node
    -- @return ViewNode
    -- @usage page = factory:analyse(node)
    analyse: ( node ) =>
        prototype = switch node.__class.__name
            when 'ModelMovie'
                ViewMovie
            when 'ModelMovieSet'
                ViewMovieSet
            when 'ModelActor'
                ViewActor
            when 'ModelSeries'
                ViewMovieSet
            when 'ModelActorSet'
                ViewActorSet
            else
                ViewNode
        prototype node
