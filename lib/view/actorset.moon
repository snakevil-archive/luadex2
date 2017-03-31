cosmo = require 'cosmo'
ViewNode = require 'view/node'

--- 演员索引节点视图组件
-- @module view/actorset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ViewActorSet
class ViewActorSet extends ViewNode
    --- 定制 CSS 块代码
    -- @function css
    -- @return string
    -- @usage html = view:css()
    css: =>
        '<style>.thumbnail img{width:100%}</style>'

    --- 定制页面内容块代码
    -- @function body
    -- @return string
    -- @usage html = view:body()
    body: =>
        cosmo.fill [=[
$cond_actors[[
  <div class="row masonry">
    $yield_actors[[
      <div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 item">
        <a class="thumbnail" href="$actor|uri">
          <img src="$actor|uri./portrait.jpg">
          <div class="caption">
            <h2 class="h4">
              <span>$actor|name</span>
              <span class="small">$age</span>
            </h2>
          </div>
        </a>
      </div>
    ]]
  </div>
]]
]=]
            cond_actors: do
                actors = @node\children!
                cosmo.cond 0 < #actors,
                    yield_actors: ->
                        names = {}
                        for actor in *actors
                            continue if names[actor.name]
                            names[actor.name] = true
                            age = actor\age!
                            cosmo.yield
                                :actor
                                age: if age
                                    age .. 'y'
