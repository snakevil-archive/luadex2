cosmo = require 'cosmo'
ViewNode = require 'view/node'

--- 演员索引节点视图组件
-- @module view/actorset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ViewActorSet
class ViewActorSet extends ViewNode
    --- 是否使用瀑布流式列表布局
    -- @field
    masonry: true

    --- 定制页面内容块代码
    -- @function body
    -- @return string
    -- @usage html = view:body()
    body: =>
        cosmo.fill [=[
$cond_actors[[
  <div class="row -list">
    $yield_actors[[
      <div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 -item">
        <a class="thumbnail" href="$uri">
          <img src="$uri./portrait.jpg">
          <div class="caption">
            <h2 class="h4">
              <span>$name</span>
              <span class="label label-info pull-right">$movies</span>
            </h2>
          </div>
        </a>
      </div>
    ]]
  </div>
]]
]=]
            if: cosmo.cif
            cond_actors: do
                actors = @node\children!
                cosmo.cond 0 < #actors,
                    yield_actors: ->
                        names = {}
                        uniqs = {}
                        for actor in *actors
                            continue if names[actor.name]
                            names[actor.name] = true
                            table.insert uniqs, actor
                        for one = 1, #uniqs
                            another = #uniqs - math.random #uniqs + 1 - one
                            uniqs[one], uniqs[another] = uniqs[another], uniqs[one]
                        for actor in *uniqs
                            cosmo.yield
                                name: actor.name
                                uri: actor.uri
                                movies: #actor\children!
